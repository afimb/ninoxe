Factory.define :time_table, :class => "Chouette::TimeTable" do |time_table|
  time_table.sequence(:comment) { |n| "Timetable #{n}" }
  time_table.sequence(:objectid) { |n| "test:Timetable:#{n}" }
end
