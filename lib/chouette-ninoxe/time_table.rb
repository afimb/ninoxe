class Chouette::TimeTable < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  
  has_many :dates, :class_name => "Chouette::TimeTableDate", :order => :position
  has_many :periods, :class_name => "Chouette::TimeTablePeriod", :order => :position

  accepts_nested_attributes_for :dates, :allow_destroy => :true
  accepts_nested_attributes_for :periods, :allow_destroy => :true

  def self.start_validity_period
    ( Chouette::TimeTableDate.all.map(&:date) + Chouette::TimeTablePeriod.all.map(&:periodstart)).min
  end
  def self.end_validity_period
    ( Chouette::TimeTableDate.all.map(&:date) + Chouette::TimeTablePeriod.all.map(&:periodend)).max
  end

  def day_by_mask(flag)
    int_day_types & flag == flag
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
    if (day) 
      self.int_day_types |= flag
    else
      self.int_day_types ^= flag
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

