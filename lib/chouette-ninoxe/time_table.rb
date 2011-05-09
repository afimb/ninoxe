class Chouette::TimeTable < Chouette::ActiveRecord
  has_many :dates, :class_name => "Chouette::TimeTableDate", :order => :position
  has_many :periods, :class_name => "Chouette::TimeTablePeriod", :order => :position
end

