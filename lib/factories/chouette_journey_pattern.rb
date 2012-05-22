Factory.define :journey_pattern, :class => "Chouette::JourneyPattern" do |jp|
  jp.sequence(:name) { |n| "JourneyPattern #{n}" }
  jp.sequence(:objectid) { |n| "test:JourneyPattern:#{n}" }

  jp.association :route, :factory => :route

  jp.after_create do |j|
    j.stop_points = j.route.stop_points
  end
  
end

