require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::Line do
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

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

  end

  describe "#transport_mode=" do
    
    it "should change transport_mode_name with TransportMode#name" do
      subject.transport_mode = mock(:name => "Test")
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
