require 'spec_helper'

describe Chouette::StopArea do
  let!(:quay) { Factory :stop_area, :area_type => "Quay" }
  let!(:boarding_position) { Factory :stop_area, :area_type => "BoardingPosition" }
  let!(:commercial_stop_point) { Factory :stop_area, :area_type => "CommercialStopPoint" }
  let!(:stop_place) { Factory :stop_area, :area_type => "StopPlace" }
  let!(:itl) { Factory :stop_area, :area_type => "ITL" }

  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  describe ".last_parent" do
    it "should return the last parent" do
      stop_place = Factory :stop_area, :area_type => "StopPlace"
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint", :parent => stop_place  
      subject = Factory :stop_area, :parent => commercial_stop_point
      subject.last_parent.should == stop_place
    end
  end


  describe ".parent" do
    it "should check if parent method exists" do
      subject = Factory :stop_area, :parent_id => commercial_stop_point.id
      subject.parent.should == commercial_stop_point
    end
  end

  describe ".possible_children" do    
    
    it "should find no possible descendant for stop area type quay" do
      subject = Factory :stop_area, :area_type => "Quay"
      subject.possible_children.should == [] 
    end

    it "should find no possible descendant for stop area type boarding position" do
      subject = Factory :stop_area, :area_type => "BoardingPosition"
      subject.possible_children.should == [] 
    end

    it "should find descendant of type quay or boarding position for stop area type commercial stop point" do
      subject = Factory :stop_area, :area_type => "CommercialStopPoint"
      subject.possible_children.should =~ [quay, boarding_position] 
    end

    it "should find no children of type stop place or commercial stop point for stop area type stop place" do
      subject = Factory :stop_area, :area_type => "StopPlace"
      subject.possible_children.should =~ [stop_place, commercial_stop_point] 
    end

  end

  describe ".possible_parentss" do

    it "should find parent type commercial stop point for stop area type boarding position" do
      subject = Factory :stop_area, :area_type => "BoardingPosition"
      subject.possible_parents.should == [commercial_stop_point] 
    end

    it "should find parent type commercial stop point for stop area type quay" do
      subject = Factory :stop_area, :area_type => "Quay"
      subject.possible_parents.should == [commercial_stop_point] 
    end    

    it "should find parent type stop place for stop area type commercial stop point" do
      subject = Factory :stop_area, :area_type => "CommercialStopPoint"
      subject.possible_parents.should == [stop_place] 
    end    

    it "should find parent type stop place for stop area type stop place" do
      subject = Factory :stop_area, :area_type => "StopPlace"
      subject.possible_parents.should == [stop_place] 
    end    


  end


  describe ".near" do

    let(:stop_area) { Factory :stop_area, :latitude => 1, :longitude => 1 }
    let(:stop_area2) { Factory :stop_area, :latitude => 1, :longitude => 1 }
    
    it "should find a StopArea at 300m from given origin" do
      Chouette::StopArea.near(stop_area.to_lat_lng.endpoint(0, 0.250, :units => :kms)).should == [stop_area]
    end

    it "should not find a StopArea at more than 300m from given origin" do
      Chouette::StopArea.near(stop_area2.to_lat_lng.endpoint(0, 0.350, :units => :kms)).should be_empty
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
