Factory.define :stop_point, :class => "Chouette::StopPoint" do |stop|
  stop.sequence(:objectid) { |n| "test:StopPoint:#{n}" }

  stop.association :route, :factory => :route
  stop.association :stop_area, :factory => :stop_area
end

