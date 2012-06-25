require 'spec_helper'

describe Chouette::Line do

  subject { Factory(:line) }

  it { should validate_presence_of :network }
  it { should validate_presence_of :company }

  it { should validate_presence_of :registration_number }
  it { should validate_uniqueness_of :registration_number }

  it { should validate_presence_of :name }
  
  # it { should validate_presence_of :objectid }
  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  # it { should validate_numericality_of :objectversion }

  describe ".last_stop_areas_parents" do
    
    it "should return stop areas if no parents" do
      line = Factory(:line_with_stop_areas)
      line.stop_areas_last_parents.should == line.stop_areas
    end

    it "should return stop areas parents if parents" do
      line = Factory(:line_with_stop_areas)
      route = Factory(:route, :line => line)
      parent = Factory(:stop_area)
      stop_areas = [ Factory(:stop_area),  Factory(:stop_area), Factory(:stop_area, :parent_id => parent.id) ]
      stop_areas.each do |stop_area|
        Factory(:stop_point, :stop_area => stop_area, :route => route)
      end   

      line.stop_areas_last_parents.should =~ line.stop_areas[0..(line.stop_areas.size - 2)].push(parent)
    end
    
  end

  describe "#stop_areas" do
    let!(:route){Factory(:route, :line => subject)}
    it "should retreive route's stop_areas" do
      subject.stop_areas.count.should == route.stop_points.count
    end
  end

  describe "#transport_mode" do

    def self.legacy_transport_mode_names
      %w{Air Train LongDistanceTrain LocalTrain RapidTransit Metro Tramway Coach Bus Ferry Waterborne PrivateVehicle Walk Trolleybus Bicycle Shuttle Taxi VAL Other}
    end
    
    legacy_transport_mode_names.each do |transport_mode_name|
      context "when transport_mode_name is #{transport_mode_name}" do
        transport_mode = Chouette::TransportMode.new(transport_mode_name.underscore)
        it "should be #{transport_mode}" do
          subject.transport_mode_name = transport_mode_name
          subject.transport_mode.should == transport_mode
        end
      end
    end
    context "when transport_mode_name is nil" do
      it "should be nil" do
        subject.transport_mode_name = nil
        subject.transport_mode.should be_nil
      end
    end

  end

  describe "#transport_mode=" do
    
    it "should change transport_mode_name with TransportMode#name" do
      subject.transport_mode = "Test"
      subject.transport_mode_name.should == "Test"
    end

  end

  describe ".transport_modes" do
    
    it "should not include unknown transport_mode" do
      Chouette::Line.transport_modes.should_not include(Chouette::TransportMode.new("unknown"))
    end

    it "should not include interchange transport_mode" do
      Chouette::Line.transport_modes.should_not include(Chouette::TransportMode.new("interchange"))
    end

  end

end
