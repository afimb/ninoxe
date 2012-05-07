# require 'composite_primary_keys'

class Chouette::TimeTableDate < Chouette::ActiveRecord
  # set_primary_keys :timetableid, :position
  belongs_to :time_table
  acts_as_list :scope => 'timetableid = #{time_table_id}'
end

