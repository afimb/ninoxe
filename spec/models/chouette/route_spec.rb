require 'spec_helper'

describe Chouette::Route do
  subject { Factory(:route) }

  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :line }
  it { should validate_presence_of :wayback_code }
  it { should validate_presence_of :direction_code }

  context "reordering methods" do
    let( :bad_stop_point_ids){subject.stop_points.map { |sp| sp.id + 1}}
    let( :ident){subject.stop_points.map(&:id)}
    let( :first_last_swap){ [ident.last] + ident[1..-2] + [ident.first]}

    describe "#reorder!" do
      context "invalid stop_point_ids" do
        let( :new_stop_point_ids) { bad_stop_point_ids}
        it { subject.reorder!( new_stop_point_ids).should be_false}
      end

      context "swaped last and first stop_point_ids" do
        let!( :new_stop_point_ids) { first_last_swap}
        let!( :old_stop_point_ids) { subject.stop_points.map(&:id) }
        let!( :old_stop_area_ids) { subject.stop_areas.map(&:id) }

        it "should keep stop_point_ids order unchanged" do
          subject.reorder!( new_stop_point_ids).should be_true
          subject.stop_points.map(&:id).should eq( old_stop_point_ids)
        end
        it "should have changed stop_area_ids order" do
          subject.reorder!( new_stop_point_ids).should be_true
          subject.reload
          subject.stop_areas.map(&:id).should eq( [old_stop_area_ids.last] + old_stop_area_ids[1..-2] + [old_stop_area_ids.first])
        end
      end
    end

    describe "#stop_point_permutation?" do
      context "invalid stop_point_ids" do
        let( :new_stop_point_ids) { bad_stop_point_ids}
        it { should_not be_stop_point_permutation( new_stop_point_ids)}
      end
      context "unchanged stop_point_ids" do
        let( :new_stop_point_ids) { ident}
        it { should be_stop_point_permutation( new_stop_point_ids)}
      end
      context "swaped last and first stop_point_ids" do
        let( :new_stop_point_ids) { first_last_swap}
        it { should be_stop_point_permutation( new_stop_point_ids)}
      end
    end
  end

  describe "#stop_points_attributes=" do
      let( :journey_pattern) { Factory( :journey_pattern, :route => subject )}
      let( :vehicle_journey) { Factory( :vehicle_journey, :journey_pattern => journey_pattern)}
      def subject_stop_points_attributes
          {}.tap do |hash|
              subject.stop_points.each_with_index { |sp,index| hash[ index.to_s ] = sp.attributes }
          end
      end
      context "route having swapped a new stop" do
          let( :new_stop_point ){Factory.build( :stop_point, :route => subject)}
          def added_stop_hash
            subject_stop_points_attributes.tap do |h|
                h["4"] = new_stop_point.attributes.merge( "position" => "4", "_destroy" => "" )
            end
          end
          let!( :new_route_size ){ subject.stop_points.size+1 }

          it "should have added stop_point in route" do
              subject.update_attributes( :stop_points_attributes => added_stop_hash)
              Chouette::Route.find( subject.id ).stop_points.size.should == new_route_size
          end
          it "should have added stop_point in route's journey pattern" do
              subject.update_attributes( :stop_points_attributes => added_stop_hash)
              Chouette::JourneyPattern.find( journey_pattern.id ).stop_points.size.should == new_route_size
          end
          it "should have added stop_point in route's vehicle journey at stop" do
              subject.update_attributes( :stop_points_attributes => added_stop_hash)
              Chouette::VehicleJourney.find( vehicle_journey.id ).vehicle_journey_at_stops.size.should == new_route_size
          end
      end
      context "route having swapped stop" do
          def swapped_stop_hash
            subject_stop_points_attributes.tap do |h|
                h[ "1" ][ "position" ] = "3"
                h[ "3" ][ "position" ] = "1"
            end
          end
          let!( :new_stop_id_list ){ subject.stop_points.map(&:id).tap {|array| array.insert( 1, array.delete_at(3)); array.insert( 3, array.delete_at(2) )}.join(",") }

          it "should have swap stop_points from route" do
              subject.update_attributes( :stop_points_attributes => swapped_stop_hash)
              Chouette::Route.find( subject.id ).stop_points.map(&:id).join(",").should == new_stop_id_list
          end
          it "should have swap stop_points from route's journey pattern" do
              subject.update_attributes( :stop_points_attributes => swapped_stop_hash)
              Chouette::JourneyPattern.find( journey_pattern.id ).stop_points.map(&:id).join(",").should == new_stop_id_list
          end
          it "should have swap stop_points from route's vehicle journey at stop" do
              subject.update_attributes( :stop_points_attributes => swapped_stop_hash)
              Chouette::VehicleJourney.find( vehicle_journey.id ).vehicle_journey_at_stops.map(&:stop_point_id).join(",").should == new_stop_id_list
          end
      end
      context "route having a deleted stop" do
          def removed_stop_hash
            subject_stop_points_attributes.tap do |h|
                h[ "1" ][ "_destroy" ] = "1"
            end
          end
          let!( :new_stop_id_list ){ subject.stop_points.map(&:id).tap {|array| array.delete_at(1) }.join(",") }

          it "should ignore deleted stop_point from route" do
              subject.update_attributes( :stop_points_attributes => removed_stop_hash)
              Chouette::Route.find( subject.id ).stop_points.map(&:id).join(",").should == new_stop_id_list
          end
          it "should ignore deleted stop_point from route's journey pattern" do
              subject.update_attributes( :stop_points_attributes => removed_stop_hash)
              Chouette::JourneyPattern.find( journey_pattern.id ).stop_points.map(&:id).join(",").should == new_stop_id_list
          end
          it "should ignore deleted stop_point from route's vehicle journey at stop" do
              subject.update_attributes( :stop_points_attributes => removed_stop_hash)
              Chouette::VehicleJourney.find( vehicle_journey.id ).vehicle_journey_at_stops.map(&:stop_point_id).join(",").should == new_stop_id_list
          end
      end
  end

  describe "#stop_points" do
    context "#find_by_stop_area" do
      context "when arg is first quay id" do
        let(:first_stop_point) { subject.stop_points.first}
        it "should return first quay" do
          subject.stop_points.find_by_stop_area( first_stop_point.stop_area_id).should eq( first_stop_point)
        end
      end
    end
  end
  describe "#stop_areas" do
    let(:line){ Factory(:line)}
    let(:route_1){ Factory(:route, :line => line)}
    let(:route_2){ Factory(:route, :line => line)}
    it "should retreive all stop_area on route" do
      route_1.stop_areas.each do |sa|
        sa.stop_points.map(&:route_id).uniq.should == [route_1.id]
      end
    end

    context "when route is looping: last and first stop area are the same" do
      it "should retreive same stop_area one last and first position" do
        route_loop = Factory(:route, :line => line)
        first_stop = Chouette::StopPoint.where( :route_id => route_loop.id, :position => 0).first
        last_stop = Factory(:stop_point, :route => route_loop, :position => 5, :stop_area => first_stop.stop_area)

        route_loop.stop_areas.size.should == 6
        route_loop.stop_areas.select {|s| s.id == first_stop.stop_area.id}.size.should == 2
      end
    end
  end

  describe "#direction_code" do
    def self.legacy_directions
      %w{A R ClockWise CounterClockWise North NorthWest West SouthWest
        South SouthEast East NorthEast}
    end
    legacy_directions.each do |direction|
      context "when direction is #{direction}" do
        direction_code = Chouette::Direction.new( Chouette::Route.direction_binding[ direction])
        it "should be #{direction_code}" do
          subject.direction = direction
          subject.direction_code.should == direction_code
        end
      end
    end
    context "when direction is nil" do
      it "should be nil" do
        subject.direction = nil
        subject.direction_code.should be_nil
      end
    end
  end
  describe "#direction_code=" do
    context "when unknown direction is provided" do
      it "should change direction to nil" do
        subject.direction_code = "dummy"
        subject.direction.should be_nil
      end
    end
    context "when an existing direction (west) is provided" do
      it "should change direction Direction.west" do
        subject.direction_code = "west"
        subject.direction.should == "West"
      end
    end
  end
  describe "#wayback_code" do
    def self.legacy_waybacks
      %w{A R}
    end
    legacy_waybacks.each do |wayback|
      context "when wayback is #{wayback}" do
        wayback_code = Chouette::Wayback.new( Chouette::Route.wayback_binding[ wayback])
        it "should be #{wayback_code}" do
          subject.wayback = wayback
          subject.wayback_code.should == wayback_code
        end
      end
    end
    context "when wayback is nil" do
      it "should be nil" do
        subject.wayback = nil
        subject.wayback_code.should be_nil
      end
    end
  end
  describe "#wayback_code=" do
    context "when unknown wayback is provided" do
      it "should change wayback to nil" do
        subject.wayback_code = "dummy"
        subject.wayback.should be_nil
      end
    end
    context "when an existing wayback (straight_forward) is provided" do
      it "should change wayback Wayback.straight_forward" do
        subject.wayback_code = "straight_forward"
        subject.wayback.should == "A"
      end
    end
  end
end
