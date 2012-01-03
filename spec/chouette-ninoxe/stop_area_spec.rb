require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::StopArea do
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  describe ".near" do

    let(:stop_area) { Chouette::StopArea.create! :latitude => 1, :longitude => 1 }
    
    it "should find a StopArea at 300m from given origin" do
      Chouette::StopArea.near(stop_area.to_lat_lng.endpoint(0, 0.250, :units => :kms)).should == [stop_area]
    end

    it "should not find a StopArea at more than 300m from given origin" do
      Chouette::StopArea.near(stop_area.to_lat_lng.endpoint(0, 0.350, :units => :kms)).should be_empty
    end

  end

  describe "#to_lat_lng" do
    
    it "should return nil if latitude is nil" do
      subject.latitude = nil
      subject.to_lat_lng.should be_nil
    end

    it "should return nil if longitude is nil" do
      subject.longitude = nil
      subject.to_lat_lng.should be_nil
    end

  end

  describe "#geometry" do
    
    it "should be nil when to_lat_lng is nil" do
      subject.stub :to_lat_lng => nil
      subject.geometry.should be_nil
    end

  end

  describe ".bounds" do
    
    it "should return transform coordinates in floats" do
      Chouette::StopArea.connection.stub :select_rows => [["113.5292500000000000", "22.1127580000000000", "113.5819330000000000", "22.2157050000000000"]]
      GeoRuby::SimpleFeatures::Envelope.should_receive(:from_coordinates).with([[113.5292500000000000, 22.1127580000000000], [113.5819330000000000, 22.2157050000000000]])
      Chouette::StopArea.bounds
    end

  end

end
