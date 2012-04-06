class Chouette::TimeTableDate < Chouette::ActiveRecord
  set_primary_keys :timetableid, :position
  belongs_to :time_table
end

