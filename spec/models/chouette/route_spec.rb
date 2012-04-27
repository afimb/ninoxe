require 'spec_helper'

describe Chouette::Route do
  subject { Factory(:route) }

  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  it { should validate_presence_of :name }

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
        first_stop = Chouette::StopPoint.where( :routeid => route_loop.id, :position => 0).first
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
