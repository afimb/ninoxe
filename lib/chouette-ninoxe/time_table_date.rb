class Chouette::TimeTableDate < Chouette::ActiveRecord
  set_primary_keys :timetableid, :date
  belongs_to :time_table
end

