require 'spec_helper'

describe Chouette::JourneyPattern do
  describe "#stop_point_ids" do
    context "for a journey_pattern using only route's stop on odd position" do
      let!(:journey_pattern){ Factory( :journey_pattern_odd)}
      let!(:vehicle_journey){ Factory( :vehicle_journey_odd, :journey_pattern => journey_pattern)}
      
      # workaroud
      #subject { journey_pattern}
      subject { Chouette::JourneyPattern.find(vehicle_journey.journey_pattern_id)}

      context "when a all route's stop have been removed from journey_pattern" do
        before(:each) do
          subject.stop_point_ids = []
        end
        it "should remove all vehicle_journey_at_stop" do
          vjas_stop_ids = Chouette::VehicleJourney.find(vehicle_journey.id).vehicle_journey_at_stops
          vjas_stop_ids.count.should == 0
        end
        it "should keep departure and arrival shortcut up to date to nil" do
          subject.arrival_stop_point_id.should be_nil
          subject.departure_stop_point_id.should be_nil
        end
      end
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
          ordered = subject.stop_points.sort { |a,b| a.position <=> b.position}

          subject.arrival_stop_point_id.should == ordered.last.id
          subject.departure_stop_point_id.should == ordered.first.id
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
          ordered = subject.stop_points.sort { |a,b| a.position <=> b.position}

          subject.arrival_stop_point_id.should == ordered.last.id
          subject.departure_stop_point_id.should == ordered.first.id
        end
      end
    end
  end
end
