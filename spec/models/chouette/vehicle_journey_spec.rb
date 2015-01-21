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
  context "when following departure times exceeds gap" do
    describe "#increasing_times" do
      before(:each) do
        subject.vehicle_journey_at_stops[0].departure_time = subject.vehicle_journey_at_stops[1].departure_time - 2.hour
        subject.vehicle_journey_at_stops[0].arrival_time = subject.vehicle_journey_at_stops[0].departure_time
        subject.vehicle_journey_at_stops[1].arrival_time = subject.vehicle_journey_at_stops[1].departure_time
      end
      it "should make instance invalid" do
        subject.increasing_times
        subject.vehicle_journey_at_stops[1].errors[:departure_time].should_not be_blank
        subject.should_not be_valid
      end
    end
    describe "#update_attributes" do
      let!(:params){ {"vehicle_journey_at_stops_attributes" => {
            "0"=>{"id" => subject.vehicle_journey_at_stops[0].id ,"arrival_time" => 1.minutes.ago,"departure_time" => 1.minutes.ago},
            "1"=>{"id" => subject.vehicle_journey_at_stops[1].id, "arrival_time" => (1.minutes.ago + 2.hour),"departure_time" => (1.minutes.ago + 2.hour)}
         }}}
      it "should return false" do
        subject.update_attributes(params).should be_false
      end
      it "should make instance invalid" do
        subject.update_attributes(params)
        subject.should_not be_valid
      end
      it "should let first vjas without any errors" do
        subject.update_attributes(params)
        subject.vehicle_journey_at_stops[0].errors.should be_empty
      end
      it "should add an error on second vjas" do
        subject.update_attributes(params)
        subject.vehicle_journey_at_stops[1].errors[:departure_time].should_not be_blank
      end
    end
  end

  context "#time_table_tokens=" do
    let!(:tm1){Factory(:time_table, :comment => "TM1")}
    let!(:tm2){Factory(:time_table, :comment => "TM2")}

    it "should return associated time table ids" do
      subject.update_attributes :time_table_tokens => [tm1.id, tm2.id].join(',')
      subject.time_tables.should include( tm1)
      subject.time_tables.should include( tm2)
    end
  end
  describe "#bounding_dates" do
    before(:each) do
      tm1 = Factory.build(:time_table, :dates =>
        [ Factory.build(:time_table_date, :date => 1.days.ago.to_date, :in_out => true),
          Factory.build(:time_table_date, :date => 2.days.ago.to_date, :in_out => true)])
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

    describe "#transport_mode_name" do

    def self.legacy_transport_modes
      %w{Air Train LongDistanceTrain LocalTrain RapidTransit Metro Tramway Coach Bus Ferry Waterborne PrivateVehicle Walk Trolleybus Bicycle Shuttle Taxi VAL Other}
    end

    legacy_transport_modes.each do |transport_mode|
      context "when transport_mode is #{transport_mode}" do
        transport_mode_name = Chouette::TransportMode.new(transport_mode.underscore)
        it "should be #{transport_mode_name}" do
          subject.transport_mode = transport_mode
          subject.transport_mode_name.should == transport_mode_name
        end
      end
    end
    context "when transport_mode is nil" do
      it "should be nil" do
        subject.transport_mode = nil
        subject.transport_mode_name.should be_nil
      end
    end

  end

  describe "#transport_mode_name=" do

    it "should change transport_mode with TransportMode#name" do
      subject.transport_mode_name = "Test"
      subject.transport_mode.should == "Test"
    end

  end

  describe ".transport_mode_names" do

    it "should not include unknown transport_mode_name" do
      Chouette::VehicleJourney.transport_mode_names.should_not include(Chouette::TransportMode.new("unknown"))
    end

    it "should not include interchange transport_mode" do
      Chouette::VehicleJourney.transport_mode_names.should_not include(Chouette::TransportMode.new("interchange"))
    end

  end

  describe "#footnote_ids=" do
    context "when line have footnotes, " do
      let!( :route) { Factory( :route ) }
      let!( :line) { route.line }
      let!( :footnote_first) {Factory( :footnote, :code => "1", :label => "dummy 1", :line => route.line)}
      let!( :footnote_second) {Factory( :footnote, :code => "2", :label => "dummy 2", :line => route.line)}


      it "should update vehicle's footnotes" do
        Chouette::VehicleJourney.find(subject.id).footnotes.should be_empty
        subject.footnote_ids = [ footnote_first.id ]
        subject.save
        Chouette::VehicleJourney.find(subject.id).footnotes.count.should == 1
      end

    end

  end

end

