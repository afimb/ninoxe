require 'spec_helper'

describe Chouette::VehicleJourneyAtStop do
  let!(:vehicle_journey){ Factory(:vehicle_journey_odd)}
  subject { vehicle_journey.vehicle_journey_at_stops.first }

  describe "#exceeds_gap?" do
    it "should return false if gap < 1.hour" do
      t1 = 1.minutes.ago
      t2 = 1.minutes.ago + 3.hour
      subject.exceeds_gap?(t1, t2).should be_true
    end
    it "should return false if gap > 2.hour" do
      t1 = 1.minutes.ago
      t2 = 1.minutes.ago + 3.minutes
      subject.exceeds_gap?(t1, t2).should be_false
    end
  end

  describe "#increasing_times_validate" do
    let(:vjas1){ vehicle_journey.vehicle_journey_at_stops[0]}
    let(:vjas2){ vehicle_journey.vehicle_journey_at_stops[1]}
    context "when vjas#arrival_time exceeds gap" do
      it "should add errors on arrival_time" do
        vjas1.arrival_time = vjas2.arrival_time - 3.hour
        vjas2.increasing_times_validate(vjas1).should be_false
        vjas2.errors.should_not be_empty
        vjas2.errors[:arrival_time].should_not be_blank
      end
    end
    context "when vjas#departure_time exceeds gap" do
      it "should add errors on departure_time" do
        vjas1.departure_time = vjas2.departure_time - 3.hour
        vjas2.increasing_times_validate(vjas1).should be_false
        vjas2.errors.should_not be_empty
        vjas2.errors[:departure_time].should_not be_blank
      end
    end
    context "when vjas does'nt exceed gap" do
      it "should not add errors" do
        vjas2.increasing_times_validate(vjas1).should be_true
        vjas2.errors.should be_empty
      end
    end
  end
end 
