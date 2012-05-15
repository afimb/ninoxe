Factory.define :line, :class => "Chouette::Line" do |line|
  line.sequence(:name) { |n| "Line #{n}" }
  line.sequence(:objectid) { |n| "test:Line:#{n}" }
  line.sequence(:transport_mode_name) { |n| "Bus" }

  line.association :network, :factory => :network
  line.association :company, :factory => :company

  line.sequence(:registration_number) { |n| "test-#{n}" }
end

Factory.define :line_with_stop_areas, :parent => :line do |line|
  line.after_build do |line|
    route = Factory(:route, :line => line)
    stop_areas = Array.new(3) { Factory(:stop_area) }
    stop_areas.each do |stop_area|
      Factory(:stop_point, :stop_area => stop_area, :route => route)
    end   
  end
end
