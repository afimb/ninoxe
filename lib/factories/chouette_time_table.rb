Factory.define :time_table_date, :class => "Chouette::TimeTableDate" do |tmd|
end

Factory.define :time_table, :class => "Chouette::TimeTable" do |time_table|
  time_table.sequence(:comment) { |n| "Timetable #{n}" }
  time_table.sequence(:objectid) { |n| "test:Timetable:#{n}" }
  time_table.after_create { |t| 
    0.upto(4) do |i|
      t.dates.create( Factory.attributes_for(:time_table_date, :date => i.days.ago.to_date))
    end
  }
end
