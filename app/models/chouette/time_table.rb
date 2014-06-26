class Chouette::TimeTable < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :version, :comment
  attr_accessible :int_day_types,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  attr_accessible :start_date, :end_date
  attr_accessible :school_holliday,:public_holliday,:market_day
  attr_accessor :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  attr_accessor :school_holliday,:public_holliday,:market_day

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
    if (day == '1')
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

end

