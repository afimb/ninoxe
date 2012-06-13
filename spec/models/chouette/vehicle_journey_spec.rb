require 'spec_helper'

describe Chouette::VehicleJourney do
  subject { Factory(:vehicle_journey_odd) }

  describe "in_relation_to_a_journey_pattern methods" do
    let!(:route) { Factory(:route)}
    let!(:journey_pattern) { Factory(:journey_pattern, :route => route)}
    let!(:journey_pattern_odd) { Factory(:journey_pattern_odd, :route => route)}
    let!(:journey_pattern_even) { Factory(:journey_pattern_even, :route => route)}

    context "when vehicle_journey is on odd stop whereas selected journey_pattern is on all stops" do
      subject { Factory(:vehicle_journey, :route => route, :journey_pattern => journey_pattern_odd)}
      describe "#extra_stops_in_relation_to_a_journey_pattern" do
        it "should be empty" do
          subject.extra_stops_in_relation_to_a_journey_pattern( journey_pattern).should be_empty
        end
      end
      describe "#extra_vjas_in_relation_to_a_journey_pattern" do
        it "should be empty" do
          subject.extra_vjas_in_relation_to_a_journey_pattern( journey_pattern).should be_empty
        end
      end
      describe "#missing_stops_in_relation_to_a_journey_pattern" do
        it "should return even stops" do
          result = subject.missing_stops_in_relation_to_a_journey_pattern( journey_pattern)
          result.should == journey_pattern_even.stop_points
        end
      end
      describe "#update_journey_pattern" do
        it "should new_record for added vjas" do
          subject.update_journey_pattern( journey_pattern)
          subject.vehicle_journey_at_stops.select{ |vjas| vjas.new_record? }.each do |vjas|
            journey_pattern_even.stop_points.should include( vjas.stop_point)
          end
        end
        it "should add vjas on each even stops" do
          subject.update_journey_pattern( journey_pattern)
          vehicle_stops = subject.vehicle_journey_at_stops.map(&:stop_point)
          journey_pattern_even.stop_points.each do |sp|
            vehicle_stops.should include(sp)
          end
        end
        it "should not mark any vjas as _destroy" do
          subject.update_journey_pattern( journey_pattern)
          subject.vehicle_journey_at_stops.any?{ |vjas| vjas._destroy }.should be_false
        end
      end
    end
    context "when vehicle_journey is on all stops whereas selected journey_pattern is on odd stops" do
      subject { Factory(:vehicle_journey, :route => route, :journey_pattern => journey_pattern)}
      describe "#missing_stops_in_relation_to_a_journey_pattern" do
        it "should be empty" do
          subject.missing_stops_in_relation_to_a_journey_pattern( journey_pattern_odd).should be_empty
        end
      end
      describe "#extra_stops_in_relation_to_a_journey_pattern" do
        it "should return even stops" do
          result = subject.extra_stops_in_relation_to_a_journey_pattern( journey_pattern_odd)
          result.should == journey_pattern_even.stop_points
        end
      end
      describe "#extra_vjas_in_relation_to_a_journey_pattern" do
        it "should return vjas on even stops" do
          result = subject.extra_vjas_in_relation_to_a_journey_pattern( journey_pattern_odd)
          result.map(&:stop_point).should == journey_pattern_even.stop_points
        end
      end
      describe "#update_journey_pattern" do
        it "should add no new vjas" do
          subject.update_journey_pattern( journey_pattern_odd)
          subject.vehicle_journey_at_stops.any?{ |vjas| vjas.new_record? }.should be_false
        end
        it "should mark vehicle_journey_at_stops as _destroy on even stops" do
          subject.update_journey_pattern( journey_pattern_odd)
          subject.vehicle_journey_at_stops.each { |vjas| 
            vjas._destroy.should == journey_pattern_even.stop_points.include?(vjas.stop_point) 
          }
        end
      end
    end

  end
  describe "#bounding_dates" do
    before(:each) do
      tm1 = Factory.build(:time_table, :dates => 
        [ Factory.build(:time_table_date, :date => 1.days.ago.to_date),
          Factory.build(:time_table_date, :date => 2.days.ago.to_date)])
      tm2 = Factory.build(:time_table, :periods =>
        [ Factory.build(:time_table_period, :period_start => 4.days.ago.to_date, :period_end => 3.days.ago.to_date)])
      tm3 = Factory.build(:time_table)
      subject.time_tables = [ tm1, tm2, tm3]
    end
    it "should return min date from associated calendars" do
      subject.bounding_dates.min.should == 4.days.ago.to_date
    end
    it "should return max date from associated calendars" do
      subject.bounding_dates.max.should == 1.days.ago.to_date
    end
  end
  context "#vehicle_journey_at_stops" do
    it "should be ordered like stop_points on route" do
      route = subject.route
      vj_stop_ids = subject.vehicle_journey_at_stops.map(&:stop_point_id)
      expected_order = route.stop_points.map(&:id).select {|s_id| vj_stop_ids.include?(s_id)}

      vj_stop_ids.should == expected_order
    end

  end
end

