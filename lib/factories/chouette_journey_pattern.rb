Factory.define :journey_pattern_common, :class => "Chouette::JourneyPattern" do |jp|
  jp.sequence(:name) { |n| "jp name #{n}" }
  jp.sequence(:published_name) { |n| "jp publishedname #{n}" }
  jp.sequence(:comment) { |n| "jp comment #{n}" }
  jp.sequence(:registration_number) { |n| "jp registration_number #{n}" }
  jp.sequence(:objectid) { |n| "test:JourneyPattern:#{n}" }

  jp.association :route, :factory => :route
end
Factory.define :journey_pattern, :parent => :journey_pattern_common  do |jp|
  jp.after_create do |j|
    j.stop_point_ids = j.route.stop_points.map(&:id)
    j.departure_stop_point_id = j.route.stop_points.first.id
    j.arrival_stop_point_id = j.route.stop_points.first.id
  end
end
Factory.define :journey_pattern_odd, :parent => :journey_pattern_common  do |jp|
  jp.after_create do |j|
    j.stop_point_ids = j.route.stop_points.select { |sp| sp.position%2==0}.map(&:id)
    j.departure_stop_point_id = j.route.stop_points.first.id
    j.arrival_stop_point_id = j.route.stop_points.first.id
  end
end
Factory.define :journey_pattern_even, :parent => :journey_pattern_common  do |jp|
  jp.after_create do |j|
    j.stop_point_ids = j.route.stop_points.select { |sp| sp.position%2==1}.map(&:id)
    j.departure_stop_point_id = j.route.stop_points.first.id
    j.arrival_stop_point_id = j.route.stop_points.first.id
  end
end


