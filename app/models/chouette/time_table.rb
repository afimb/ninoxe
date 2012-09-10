class Chouette::TimeTable < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  
  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :version, :comment, :int_day_types,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  attr_accessor :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday

  has_many :dates, :class_name => "Chouette::TimeTableDate", :order => :position, :dependent => :destroy
  has_many :periods, :class_name => "Chouette::TimeTablePeriod", :order => :position, :dependent => :destroy

  def self.object_id_key
    "Timetable"
  end

  accepts_nested_attributes_for :dates, :allow_destroy => :true
  accepts_nested_attributes_for :periods, :allow_destroy => :true

  validates_presence_of :comment

  def self.start_validity_period
    [Chouette::TimeTableDate.minimum(:date),Chouette::TimeTablePeriod.minimum(:period_start)].compact.min 
  end
  def self.end_validity_period
    [Chouette::TimeTableDate.maximum(:date),Chouette::TimeTablePeriod.maximum(:period_end)].compact.max 
  end

  def validity_out_from_on?(expected_date)
    return false if bounding_dates.empty?
    bounding_dates.max <= expected_date
  end
  def validity_out_between?(start_date, end_date)
    return false if bounding_dates.empty?
    start_date < bounding_dates.max  &&
      bounding_dates.max <= end_date
  end
  def self.validity_out_from_on?(expected_date,limit=0)
    expired = []
    includes(:dates,:periods).find_each do |tm|
      expired << tm if tm.validity_out_from_on?( expected_date)
      break if (limit > 0 && expired.size == limit) 
    end
    expired
  end
  def self.validity_out_between?(start_date, end_date,limit=0)
    expired = []
    includes(:dates,:periods).find_each do |tm|
      expired << tm if tm.validity_out_between?( start_date, end_date)
      break if (limit > 0 && expired.size == limit) 
    end
    expired
  end

  def bounding_dates
    (self.dates.map(&:date) + self.periods.map(&:period_start) + self.periods.map(&:period_end)).compact
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
  
  def set_day(day,flag)
    if (day == '1') 
      self.int_day_types |= flag
    else
      self.int_day_types &= ~flag
    end
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
  
end

