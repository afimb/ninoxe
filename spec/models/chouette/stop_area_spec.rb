require 'spec_helper'

describe Chouette::StopArea do
  let!(:quay) { Factory :stop_area, :area_type => "Quay" }
  let!(:boarding_position) { Factory :stop_area, :area_type => "BoardingPosition" }
  let!(:commercial_stop_point) { Factory :stop_area, :area_type => "CommercialStopPoint" }
  let!(:stop_place) { Factory :stop_area, :area_type => "StopPlace" }
  let!(:itl) { Factory :stop_area, :area_type => "ITL" }

  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :area_type }

  describe ".children_in_depth" do
    it "should return all the deepest children from stop area" do
      subject = Factory :stop_area, :area_type => "StopPlace"
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint", :parent => subject 
      commercial_stop_point2 = Factory :stop_area, :area_type => "CommercialStopPoint", :parent => commercial_stop_point
      quay = Factory :stop_area, :parent => commercial_stop_point
      subject.children_in_depth.should =~ [commercial_stop_point, commercial_stop_point2, quay]
    end
  end


  describe ".stop_area_type" do
    it "should have area_type of BoardingPosition when stop_area_type is set to boarding_position" do
      subject = Factory :stop_area, :stop_area_type => "boarding_position"
      subject.area_type.should == "BoardingPosition"
    end
    it "should have area_type of Quay when stop_area_type is set to quay" do
      subject = Factory :stop_area, :stop_area_type => "quay"
      subject.area_type.should == "Quay"
    end
    it "should have area_type of CommercialStopPoint when stop_area_type is set to commercial_stop_point" do
      subject = Factory :stop_area, :stop_area_type => "commercial_stop_point"
      subject.area_type.should == "CommercialStopPoint"
    end
    it "should have area_type of StopPlace when stop_area_type is set to stop_place" do
      subject = Factory :stop_area, :stop_area_type => "stop_place"
      subject.area_type.should == "StopPlace"
    end
    it "should have area_type of ITL when stop_area_type is set to itl" do
      subject = Factory :stop_area, :stop_area_type => "itl"
      subject.area_type.should == "ITL"
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

    it "should find no children of type ITL for stop area type ITL" do
      subject = Factory :stop_area, :area_type => "ITL"
      subject.possible_children.should =~ [stop_place, commercial_stop_point, quay, boarding_position] 
    end

  end

  describe ".possible_parents" do

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

  describe "#default_position" do
    
    it "should return nil when StopArea.bounds is nil" do
      Chouette::StopArea.stub :bounds => nil
      subject.default_position.should be_nil
    end

    it "should return StopArea.bounds center" do
      Chouette::StopArea.stub :bounds => mock(:center => "center")
      subject.default_position.should == Chouette::StopArea.bounds.center
    end

  end

end
