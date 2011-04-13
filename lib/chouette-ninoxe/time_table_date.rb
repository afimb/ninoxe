class Chouette::TimeTableDate < Chouette::ActiveRecord
  set_primary_key :timetableid
  set_table_name :timetable_date
  belongs_to :time_table, :class_name => "Chouette::TimeTable", :foreign_key => "timetableid"
  
end

