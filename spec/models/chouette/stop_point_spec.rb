require 'spec_helper'

describe Chouette::StopPoint do
  let!(:vehicle_journey) { Factory(:vehicle_journey)}
  subject { Chouette::Route.find( vehicle_journey.route_id).stop_points.first }

  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  describe "#destroy" do
    before(:each) do
      @vehicle = Factory(:vehicle_journey)
      @stop_point = Chouette::Route.find( @vehicle.route_id).stop_points.first
    end
    def vjas_stop_point_ids( vehicle_id)
      Chouette::VehicleJourney.find( vehicle_id).vehicle_journey_at_stops.map(&:stop_point_id)
    end
    def jpsp_stop_point_ids( journey_id)
      Chouette::JourneyPattern.find( journey_id).stop_points.map(&:id)
    end
    it "should remove dependent vehicle_journey_at_stop" do
      vjas_stop_point_ids(@vehicle.id).should include(@stop_point.id)

      @stop_point.destroy

      vjas_stop_point_ids(@vehicle.id).should_not include(@stop_point.id)
    end
    it "should remove dependent journey_pattern_stop_point" do
      jpsp_stop_point_ids(@vehicle.journey_pattern_id).should include(@stop_point.id)

      @stop_point.destroy

      jpsp_stop_point_ids(@vehicle.journey_pattern_id).should_not include(@stop_point.id)
    end
  end
end
