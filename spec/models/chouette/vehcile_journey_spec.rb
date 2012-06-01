require 'spec_helper'

describe Chouette::VehicleJourney do
  subject { Factory(:vehicle_journey_odd) }

  context "#vehicle_journey_at_stops" do
    it "should be ordered like stop_points on route" do
      route = subject.route
      vj_stop_ids = subject.vehicle_journey_at_stops.map(&:stop_point_id)
      expected_order = route.stop_points.map(&:id).select {|s_id| vj_stop_ids.include?(s_id)}

      vj_stop_ids.should == expected_order
    end

  end
end

