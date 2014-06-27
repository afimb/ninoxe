Factory.define :vehicle_journey_common, :class => "Chouette::VehicleJourney" do |v|
  v.sequence(:objectid) { |n| "test:VehicleJourney:#{n}" }
end

Factory.define :vehicle_journey, :parent => :vehicle_journey_common do |v|
  v.association :journey_pattern, :factory => :journey_pattern
  v.after_build do |vj|
    vj.route_id = vj.journey_pattern.route_id
  end
  v.after_create do |vj|
    vj.journey_pattern.stop_points.each_with_index do |sp,index|
      vj.vehicle_journey_at_stops << Factory( :vehicle_journey_at_stop, 
               :vehicle_journey => vj, 
               :stop_point => sp, 
               :arrival_time => (-1 * index).minutes.ago, 
               :departure_time => (-1 * index).minutes.ago)
    end
  end
end
Factory.define :vehicle_journey_odd, :parent => :vehicle_journey_common do |v|
  v.association :journey_pattern, :factory => :journey_pattern_odd
  v.after_build do |vj|
    vj.route_id = vj.journey_pattern.route_id
  end
  v.after_create do |vj|
    vj.journey_pattern.stop_points.each_with_index do |sp,index|
      vj.vehicle_journey_at_stops << Factory( :vehicle_journey_at_stop, 
               :vehicle_journey => vj, 
               :stop_point => sp, 
               :arrival_time => (-1 * index).minutes.ago, 
               :departure_time => (-1 * index).minutes.ago)
    end
  end
end
Factory.define :vehicle_journey_even, :parent => :vehicle_journey_common do |v|
  v.association :journey_pattern, :factory => :journey_pattern_even
  v.after_build do |vj|
    vj.route_id = vj.journey_pattern.route_id
  end
  v.after_create do |vj|
    vj.journey_pattern.stop_points.each_with_index do |sp,index|
      vj.vehicle_journey_at_stops << Factory( :vehicle_journey_at_stop, 
               :vehicle_journey => vj, 
               :stop_point => sp, 
               :arrival_time => (-1 * index).minutes.ago, 
               :departure_time => (-1 * index).minutes.ago)
    end
  end
end


