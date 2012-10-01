Factory.define :time_table_date, :class => "Chouette::TimeTableDate" do |tmd|
end
Factory.define :time_table_period, :class => "Chouette::TimeTablePeriod" do |tmp|
end

Factory.define :time_table, :class => "Chouette::TimeTable" do |time_table|
  time_table.sequence(:comment) { |n| "Timetable #{n}" }
  time_table.sequence(:objectid) { |n| "test:Timetable:#{n}" }
  time_table.after_create { |t| 
    0.upto(4) do |i|
      t.dates.create(Factory.attributes_for(:time_table_date, :date => i.days.since.to_date))
    end
    start_date = Date.today
    end_date = start_date + 10
    0.upto(3) do |i|
      t.periods.create(Factory.attributes_for(:time_table_period, :period_start => start_date, :period_end => end_date))
      start_date = start_date + 20
      end_date = start_date + 10
    end
  }
end
