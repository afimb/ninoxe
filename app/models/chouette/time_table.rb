class Chouette::TimeTable < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :version, :comment
  attr_accessible :int_day_types,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  attr_accessible :start_date, :end_date
  attr_accessible :school_holliday,:public_holliday,:market_day
  attr_accessor :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  attr_accessor :school_holliday,:public_holliday,:market_day
  
  acts_as_taggable
  attr_accessible :tag_list

  has_many :dates, inverse_of: :time_table, :validate => :true, :class_name => "Chouette::TimeTableDate", :order => :date, :dependent => :destroy, :after_add => :shortcuts_update, :after_remove => :shortcuts_update
  has_many :periods, inverse_of: :time_table, :validate => :true, :class_name => "Chouette::TimeTablePeriod", :order => :period_start, :dependent => :destroy, :after_add => :shortcuts_update, :after_remove => :shortcuts_update

  def self.object_id_key
    "Timetable"
  end

  accepts_nested_attributes_for :dates, :allow_destroy => :true
  accepts_nested_attributes_for :periods, :allow_destroy => :true
  attr_accessible :dates_attributes,:periods_attributes

  validates_presence_of :comment
  validates_associated :dates
  validates_associated :periods

  def self.start_validity_period
    [Chouette::TimeTable.minimum(:start_date)].compact.min
  end
  def self.end_validity_period
    [Chouette::TimeTable.maximum(:end_date)].compact.max
  end

  def shortcuts_update(date=nil)
    dates_array = bounding_dates
    #if new_record?
      if dates_array.empty?
        self.start_date=nil
        self.end_date=nil
      else
        self.start_date=dates_array.min
        self.end_date=dates_array.max
      end
    #else
     # if dates_array.empty?
     #   update_attributes :start_date => nil, :end_date => nil
     # else
     #   update_attributes :start_date => dates_array.min, :end_date => dates_array.max
     # end
    #end
  end

  def validity_out_from_on?(expected_date)
    return false unless self.end_date
    self.end_date <= expected_date
  end
  def validity_out_between?(starting_date, ending_date)
    return false unless self.start_date
    starting_date < self.end_date  &&
      self.end_date <= ending_date
  end
  def self.validity_out_from_on?(expected_date,limit=0)
    if limit==0
      Chouette::TimeTable.where("end_date <= ?", expected_date)
    else
      Chouette::TimeTable.where("end_date <= ?", expected_date).limit( limit)
    end
  end
  def self.validity_out_between?(start_date, end_date,limit=0)
    if limit==0
      Chouette::TimeTable.where( "? < end_date", start_date).where( "end_date <= ?", end_date)
    else
      Chouette::TimeTable.where( "? < end_date", start_date).where( "end_date <= ?", end_date).limit( limit)
    end
  end

  # Return days which intersects with the time table dates and periods
  def intersects(days)
    [].tap do |intersect_days|
      days.each do |day|
        intersect_days << day if include_day?(day)
      end
    end
  end

  def include_day?(day)
    include_in_dates?(day) || include_in_periods?(day)
  end

  def include_in_dates?(day)
    self.dates.any?{ |d| d.date === day && d.in_out == true }
  end

  def excluded_date?(day)
    self.dates.any?{ |d| d.date === day && d.in_out == false }
  end

  def include_in_periods?(day)
    self.periods.any?{ |period| period.period_start <= day &&
                                day <= period.period_end &&
                                valid_days.include?(day.cwday) &&
                                ! excluded_date?(day) }
  end

  def include_in_overlap_dates?(day)
    return false if self.excluded_date?(day)

    counter = self.dates.select{ |d| d.date === day}.size + self.periods.select{ |period| period.period_start <= day && day <= period.period_end && valid_days.include?(day.cwday) }.size
    counter <= 1 ? false : true
   end

  def periods_max_date
    return nil if self.periods.empty?

    min_start = self.periods.map(&:period_start).compact.min
    max_end = self.periods.map(&:period_end).compact.max
    result = nil

    if max_end && min_start
      max_end.downto( min_start) do |date|
        if self.valid_days.include?(date.cwday) && !self.excluded_date?(date)
            result = date
            break
        end
      end
    end
    result
  end
  def periods_min_date
    return nil if self.periods.empty?

    min_start = self.periods.map(&:period_start).compact.min
    max_end = self.periods.map(&:period_end).compact.max
    result = nil

    if max_end && min_start
      min_start.upto(max_end) do |date|
        if self.valid_days.include?(date.cwday) && !self.excluded_date?(date)
            result = date
            break
        end
      end
    end
    result
  end
  def bounding_dates
    bounding_min = self.dates.select{|d| d.in_out}.map(&:date).compact.min
    bounding_max = self.dates.select{|d| d.in_out}.map(&:date).compact.max

    unless self.periods.empty?
      bounding_min = periods_min_date if periods_min_date &&
          (bounding_min.nil? || (periods_min_date < bounding_min))

      bounding_max = periods_max_date if periods_max_date &&
          (bounding_max.nil? || (bounding_max < periods_max_date))
    end

    [bounding_min, bounding_max].compact
  end

  def day_by_mask(flag)
    int_day_types & flag == flag
  end

  def self.day_by_mask(int_day_types,flag)
    int_day_types & flag == flag
  end


  def valid_days
    # Build an array with day of calendar week (1-7, Monday is 1).
    [].tap do |valid_days|
      valid_days << 1  if monday
      valid_days << 2  if tuesday
      valid_days << 3  if wednesday
      valid_days << 4  if thursday
      valid_days << 5  if friday
      valid_days << 6  if saturday
      valid_days << 7  if sunday
    end
  end

  def self.valid_days(int_day_types)
    # Build an array with day of calendar week (1-7, Monday is 1).
    [].tap do |valid_days|
      valid_days << 1  if day_by_mask(int_day_types,4)
      valid_days << 2  if day_by_mask(int_day_types,8)
      valid_days << 3  if day_by_mask(int_day_types,16)
      valid_days << 4  if day_by_mask(int_day_types,32)
      valid_days << 5  if day_by_mask(int_day_types,64)
      valid_days << 6  if day_by_mask(int_day_types,128)
      valid_days << 7  if day_by_mask(int_day_types,256)
    end
  end

  def monday
    day_by_mask(4)
  end
  def tuesday
    day_by_mask(8)
  end
  def wednesday
    day_by_mask(16)
  end
  def thursday
    day_by_mask(32)
  end
  def friday
    day_by_mask(64)
  end
  def saturday
    day_by_mask(128)
  end
  def sunday
    day_by_mask(256)
  end
  def school_holliday
    day_by_mask(512)
  end
  def public_holliday
    day_by_mask(1024)
  end
  def market_day
    day_by_mask(2048)
  end

  def set_day(day,flag)
    if day == '1' || day == true
      self.int_day_types |= flag
    else
      self.int_day_types &= ~flag
    end
    shortcuts_update
  end

  def monday=(day)
    set_day(day,4)
  end
  def tuesday=(day)
    set_day(day,8)
  end
  def wednesday=(day)
    set_day(day,16)
  end
  def thursday=(day)
    set_day(day,32)
  end
  def friday=(day)
    set_day(day,64)
  end
  def saturday=(day)
    set_day(day,128)
  end
  def sunday=(day)
    set_day(day,256)
  end
  def school_holliday=(day)
    set_day(day,512)
  end
  def public_holliday=(day)
    set_day(day,1024)
  end
  def market_day=(day)
    set_day(day,2048)
  end

  def effective_days_of_period(period,valid_days=self.valid_days)
    days = []
      period.period_start.upto(period.period_end) do |date|
        if valid_days.include?(date.cwday) && !self.excluded_date?(date)
            days << date
        end
      end
    days
  end
  
  def effective_days(valid_days=self.valid_days)
    days=self.effective_days_of_periods(valid_days)
    self.dates.each do |d|
      days |= [d.date] if d.in_out
    end
    days.sort
  end
  
  def effective_days_of_periods(valid_days=self.valid_days)
    days = []
    self.periods.each { |p| days |= self.effective_days_of_period(p,valid_days)}
    days.sort
  end
  
  def clone_periods
    periods = []
    self.periods.each { |p| periods << p.copy}
    periods
  end
  
  def included_days
    days = []
    self.dates.each do |d|
      days |= [d.date] if d.in_out
    end
    days.sort
  end
  
  def excluded_days
    days = []
    self.dates.each do |d|
      days |= [d.date] unless d.in_out
    end
    days.sort
  end

  
  # produce a copy of periods without anyone overlapping or including another
  def optimize_periods
    periods = self.clone_periods
    optimized = []
    i=0
    while i < periods.length
      p1 = periods[i]
      optimized << p1
      j= i+1
      while j < periods.length
        p2 = periods[j]
        if p1.contains? p2
          periods.delete p2
        elsif p1.overlap? p2
          p1.period_start = [p1.period_start,p2.period_start].min
          p1.period_end = [p1.period_end,p2.period_end].max
          periods.delete p2
        else
          j += 1
        end
      end
      i+= 1
    end
    optimized.sort { |a,b| a.period_start <=> b.period_start}
  end
  
  # merge effective days from another timetable
  def merge!(another_tt)
    # save special flags 
    sh = self.school_holliday && another_tt.school_holliday
    ph = self.public_holliday && another_tt.public_holliday
    md = self.market_day && another_tt.market_day
    # clear special days
    self.school_holliday=0
    self.public_holliday=0
    self.market_day=0
    # if one tt has no period, just merge lists
    if self.periods.empty? || another_tt.periods.empty?
      if !another_tt.periods.empty?
        # copy periods 
        self.periods = another_tt.clone_periods
        # set valid_days 
        self.int_day_types = another_tt.int_day_types 
      end
      # merge dates
      self.dates ||= []
      another_tt.dates.each do |d|
        if d.in_out == true
          if self.excluded_date?(d.date) 
             self.dates.each do |date|
               if date.date === d 
                 date.in_out = true
               end
             end
          elsif !self.include_in_dates?(d.date)
             self.dates << Chouette::TimeTableDate.new(:date => d.date, :in_out => true)
          end
        end
      end
    else
      # check if periods can be kept
      common_day_types = self.int_day_types & another_tt.int_day_types & 508
      periods = self.optimize_periods
      another_periods = another_tt.optimize_periods
      # if common day types : merge periods
      if common_day_types != 0
        # add not common days of both periods as peculiar days
        self.effective_days_of_periods(self.class.valid_days(self.int_day_types ^ common_day_types)).each do |d| 
          self.dates |= [Chouette::TimeTableDate.new(:date => d, :in_out => true)] 
        end
        another_tt.effective_days_of_periods(self.class.valid_days(another_tt.int_day_types ^ common_day_types)).each do |d| 
          if self.excluded_date?(d)
             self.dates.each do |date|
               if date.date === d 
                 date.in_out = true
               end
             end
          elsif !self.include_in_dates?(d)
             self.dates << Chouette::TimeTableDate.new(:date => d, :in_out => true)
          end
        end
        # merge periods
        periods |= another_periods
        self.periods = periods
        self.int_day_types = common_day_types
        self.periods =self.optimize_periods
      else
        # convert all period in days
        self.effective_days_of_periods.each do |d| 
          self.dates << Chouette::TimeTableDate.new(:date => d, :in_out => true) unless self.include_in_dates?(d)
        end
        another_tt.effective_days_of_periods.each do |d| 
          if self.excluded_date?(d)
             self.dates.each do |date|
               if date.date === d 
                 date.in_out = true
               end
             end
          elsif !self.include_in_dates?(d)
             self.dates << Chouette::TimeTableDate.new(:date => d, :in_out => true)
          end
        end
      end
    end
    # if excluded dates are valid in other tt , remove it from result
    self.dates.each do |date|
      if date.in_out == false
        if another_tt.include_day?(date.date)
          date.in_out = true
        end
      end
    end
    
    # if peculiar dates are valid in new periods, remove them
    if !self.periods.empty?
      days_in_period = self.effective_days_of_periods
      dates = []
      self.dates.each do |date|
        dates << date unless date.in_out && days_in_period.include?(date.date)
      end
      self.dates = dates
    end
    self.dates.sort! { |a,b| a.date <=> b.date}
    
    # set special flags if common
    self.school_holliday = sh
    self.public_holliday = ph
    self.market_day = md
    self
  end
  
  # remove dates form tt which aren't in another_tt
  def intersect!(another_tt)
    
    common_day_types = self.int_day_types & another_tt.int_day_types & 508
    # save special flags 
    sh = self.school_holliday || another_tt.school_holliday
    ph = self.public_holliday || another_tt.public_holliday
    md = self.market_day || another_tt.market_day
    # if both tt have periods with common day_types, intersect them
    if !self.periods.empty? && !another_tt.periods.empty? 
      if common_day_types != 0
        periods = []
        days = []
        valid_days = self.class.valid_days(common_day_types)
        self.optimize_periods.each do |p1|
          another_tt.optimize_periods.each do |p2|
            if p1.overlap? p2
              # create period for intersection
              pi = Chouette::TimeTablePeriod.new(:period_start => [p1.period_start,p2.period_start].max,
                                                 :period_end => [p1.period_end,p2.period_end].min)
              if !self.effective_days_of_period(pi,valid_days).empty? && !another_tt.effective_days_of_period(pi,valid_days).empty?
                if pi.period_start == pi.period_end
                  days << pi.period_start
                else
                  periods << pi
                end
              end
            end
          end
        end
        # intersect dates
        days |= another_tt.intersects(self.included_days) & self.intersects(another_tt.included_days)
        excluded_days = self.excluded_days | another_tt.excluded_days
        self.dates.clear
        days.each {|day| self.dates << Chouette::TimeTableDate.new( :date =>day, :in_out => true)}
        self.periods = periods
        self.int_day_types = common_day_types
        days_of_periods = self.effective_days_of_periods
        excluded_days.each do |day| 
          self.dates << Chouette::TimeTableDate.new( :date =>day, :in_out => false) if days_of_periods.contains?(day)
        end  
      end
    else
      # transform tt as effective dates and get common ones
      days = another_tt.intersects(self.effective_days) & self.intersects(another_tt.effective_days)
      self.dates.clear
      days.each {|d| self.dates << Chouette::TimeTableDate.new( :date =>d, :in_out => true)}
      self.periods.clear
      self.int_day_types = 0
    end
    self.dates.sort! { |a,b| a.date <=> b.date}
    
    # set special flags if common
    self.school_holliday = sh
    self.public_holliday = ph
    self.market_day = md
    self    
  end
  
  
  def disjoin!(another_tt)
    common_day_types = self.int_day_types & another_tt.int_day_types & 508
    # save special flags 
    sh = self.school_holliday && !another_tt.school_holliday
    ph = self.public_holliday && !another_tt.public_holliday
    md = self.market_day && !another_tt.market_day
    # if both tt have periods with common day_types, reduce first ones to exclude second
    if !self.periods.empty? && !another_tt.periods.empty? 
      if common_day_types != 0
        periods = []
        days = []
        valid_days = self.class.valid_days(self.int_day_types & ~another_tt.int_day_types)
        self.optimize_periods.each do |p1|
          deleted = false
          another_tt.optimize_periods.each do |p2|
            if  p2.contains? p1
              # p1 is removed, keep remaining dates as included
              days |= self.effective_days_of_period(p1,valid_days)
              deleted = true
              break
            elsif  p1.contains? p2
              # p1 is broken in 2; keep remaining dates covered by p2 as included
              days |= self.effective_days_of_period(p2,valid_days)
              if  p1.period_start != p2.period_start
                pi = Chouette::TimeTablePeriod.new(:period_start => p1.period_start,
                                                   :period_end => p2.period_start - 1)
                if !self.effective_days_of_period(pi,valid_days).empty?                                   
                  if pi.period_start == pi.period_end
                    days << pi.period_start
                  else
                    periods << pi
                  end
                end
              end
              if p1.period_end != p2.period_end
                 p1.period_start = p2.period_end + 1
              else
                 deleted = true
                 break   
              end
            elsif  p1.overlap? p2
              if p2.period_start <= p1.period_start
                p2.period_start = p1.period_start
                p1.period_start = p2.period_end + 1
              else 
                p2.period_end = p1.period_end
                p1.period_end = p2.period_start - 1
              end
              days |= self.effective_days_of_period(p2,valid_days)
            end
          end
          periods << p1 unless deleted
        end
        # rebuild periods and dates
        self.periods = periods
        if periods.empty?
          self.int_day_types = 0
        end
        days.each { |d| self.dates |= [Chouette::TimeTableDate.new( :date =>d, :in_out => true)] }
      end
    else 
      # otherwise remove or exclude dates and delete empty periods
      # first remove peculiar dates
      days = self.intersects(another_tt.effective_days)
      self.dates -= self.dates.select{|date| days.include?(date.date)}
      # then add excluded dates
      self.intersects(another_tt.effective_days).each do |d|
        self.dates |= [Chouette::TimeTableDate.new( :date =>d, :in_out => false)]
      end
    end  
    self.dates.sort! { |a,b| a.date <=> b.date}
    self.periods.sort! { |a,b| a.period_start <=> b.period_start}
    
    # set special flags if common
    self.school_holliday = sh
    self.public_holliday = ph
    self.market_day = md
    self    
  end
  
  def duplicate
    tt = self.deep_clone :include => [:periods, :dates], :except => :object_version
    tt.uniq_objectid
    tt.comment = I18n.t("activerecord.copy", :comment => self.comment)
    tt
  end
  
end

