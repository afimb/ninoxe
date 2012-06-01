require 'spec_helper'

describe Chouette::JourneyPattern do
  describe "#stop_point_ids" do
    context "for a journey_pattern using only route's stop on odd position" do
      let!(:vehicle_journey){ Factory( :vehicle_journey_odd)}
      
      # workaroud
      # subject { vehicle_journey.journey_pattern}
      subject { Chouette::JourneyPattern.find(vehicle_journey.journey_pattern_id)}

      context "when a route's stop has been removed from journey_pattern" do
        let!(:last_stop_id){ subject.stop_point_ids.last}
        before(:each) do
          subject.stop_point_ids = subject.stop_point_ids - [last_stop_id]
        end
        it "should remove vehicle_journey_at_stop for last stop" do
          vjas_stop_ids = Chouette::VehicleJourney.find(vehicle_journey.id).vehicle_journey_at_stops.map(&:stop_point_id)
          vjas_stop_ids.count.should == subject.stop_point_ids.size
          vjas_stop_ids.should_not include( last_stop_id)
        end
        it "should keep departure and arrival shortcut up to date" do
          subject.stop_points.last.id.should == subject.arrival_stop_point_id
          subject.stop_points.first.id.should == subject.departure_stop_point_id
        end
      end
      context "when a route's stop has been added in journey_pattern" do
        let!(:new_stop){ subject.route.stop_points[1]}
        before(:each) do
          subject.stop_point_ids = subject.stop_point_ids + [new_stop.id]
        end
        it "should add a new vehicle_journey_at_stop for that stop" do
          vjas_stop_ids = Chouette::VehicleJourney.find(vehicle_journey.id).vehicle_journey_at_stops.map(&:stop_point_id)
          vjas_stop_ids.count.should == subject.stop_point_ids.size
          vjas_stop_ids.should include( new_stop.id)
        end
        it "should keep departure and arrival shortcut up to date" do
          subject.stop_points.last.id.should == subject.arrival_stop_point_id
          subject.stop_points.first.id.should == subject.departure_stop_point_id
        end
      end
    end
  end
end
