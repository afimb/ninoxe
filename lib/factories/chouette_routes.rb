Factory.define :route_common, :class => "Chouette::Route" do |route|
  route.sequence(:name) { |n| "Route #{n}" }
  route.sequence(:published_name) { |n| "Long route #{n}" }
  route.sequence(:number) { |n| "#{n}" }
  route.sequence(:wayback_code) { |n| Chouette::Wayback.new( n % 2) }
  route.sequence(:direction_code) { |n| Chouette::Direction.new( n % 12) }
  route.sequence(:objectid) { |n| "test:Route:#{n}" }

  route.association :line, :factory => :line
end

Factory.define :route, :class => "Chouette::Route", :parent => :route_common do |route|
  route.after_create do |r|
    0.upto(4) do |i|
      Factory(:stop_point, :position => i, :route => r)
    end
  end
  
end

