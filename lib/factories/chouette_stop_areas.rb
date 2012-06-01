Factory.define :stop_area, :class => "Chouette::StopArea" do |stop_area|
  stop_area.latitude 10 * rand
  stop_area.longitude 10 * rand
  stop_area.sequence(:name) { |n| "StopArea #{n}" }
  stop_area.area_type "CommercialStopPoint"
  stop_area.sequence(:objectid) { |n| "test:StopArea:#{n}" }
  stop_area.sequence(:registration_number) { |n| "test-#{n}" }
end
