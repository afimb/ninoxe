Factory.define :access_point, :class => "Chouette::AccessPoint" do |access_point|
  access_point.latitude 10 * rand
  access_point.longitude 10 * rand
  access_point.sequence(:name) { |n| "AccessPoint #{n}" }
  access_point.access_type "InOut"
  access_point.sequence(:objectid) { |n| "test:AccessPoint:#{n}" }
  access_point.association :stop_area, :factory => :stop_area
end
