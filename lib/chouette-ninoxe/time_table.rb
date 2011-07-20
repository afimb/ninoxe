class Chouette::TimeTable < Chouette::ActiveRecord
  has_many :dates, :class_name => "Chouette::TimeTableDate", :order => :position
  has_many :periods, :class_name => "Chouette::TimeTablePeriod", :order => :position

  def self.start_validity_period
    ( Chouette::TimeTableDate.all.map(&:date) + Chouette::TimeTablePeriod.all.map(&:periodstart)).min
  end
  def self.end_validity_period
    ( Chouette::TimeTableDate.all.map(&:date) + Chouette::TimeTablePeriod.all.map(&:periodend)).max
  end

end

