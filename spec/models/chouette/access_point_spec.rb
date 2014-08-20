require 'spec_helper'

describe Chouette::AccessPoint do

  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  it { should validate_presence_of :name }
  it { should validate_numericality_of :latitude }
  it { should validate_numericality_of :longitude }
  
  describe ".latitude" do
    it "should accept -90 value" do
      subject = Factory :access_point
      subject.latitude = -90
      subject.valid?.should be_true
    end
    it "should reject < -90 value" do
      subject = Factory :access_point
      subject.latitude = -90.0001
      subject.valid?.should be_false
    end
    it "should accept 90 value" do
      subject = Factory :access_point
      subject.latitude = 90
      subject.valid?.should be_true
    end
    it "should reject > 90 value" do
      subject = Factory :access_point
      subject.latitude = 90.0001
      subject.valid?.should be_false
    end
  end

  describe ".longitude" do
    it "should accept -180 value" do
      subject = Factory :access_point
      subject.longitude = -180
      subject.valid?.should be_true
    end
    it "should reject < -180 value" do
      subject = Factory :access_point
      subject.longitude = -180.0001
      subject.valid?.should be_false
    end
    it "should accept 180 value" do
      subject = Factory :access_point
      subject.longitude = 180
      subject.valid?.should be_true
    end
    it "should reject > 180 value" do
      subject = Factory :access_point
      subject.longitude = 180.0001
      subject.valid?.should be_false
    end
  end

  describe ".long_lat" do
    it "should accept longitude and latitude both as nil" do
      subject = Factory :access_point
      subject.longitude = nil
      subject.latitude = nil
      subject.valid?.should be_true
    end
    it "should accept longitude and latitude both numerical" do
      subject = Factory :access_point
      subject.longitude = 10
      subject.latitude = 10
      subject.valid?.should be_true
    end
    it "should reject longitude nil with latitude numerical" do
      subject = Factory :access_point
      subject.longitude = nil
      subject.latitude = 10
      subject.valid?.should be_false
    end
    it "should reject longitude numerical with latitude nil" do
      subject = Factory :access_point
      subject.longitude = 10
      subject.latitude = nil
      subject.valid?.should be_false
    end
  end 

  describe "#access_type" do
    def self.legacy_access_types
      %w{In Out InOut}
    end
    
    legacy_access_types.each do |access_type|
      context "when access_type is #{access_type}" do
        access_point_type = Chouette::AccessPointType.new(access_type.underscore)
        it "should be #{access_point_type}" do
          subject.access_type = access_type
          subject.access_point_type.should == access_point_type
        end
      end
    end
  end

  describe "#access_point_type=" do    
    it "should change access_type with Chouette::AccessPointType#name" do
      subject.access_point_type = "in_out"
      subject.access_type.should == "InOut"
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

  describe "#generic_access_link_matrix" do
    it "should have 2 generic_access_links in matrix" do
      stop_place = Factory :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      subject = Factory :access_point, :stop_area => stop_place
      subject.generic_access_link_matrix.size.should == 2
    end
    
    it "should have new generic_access_links in matrix" do
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
      subject = Factory :access_point, :stop_area => commercial_stop_point
      subject.generic_access_link_matrix.each do |link|
        link.id.should be_nil
      end
    end
    it "should have only last generic_access_links as new in matrix" do
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
      subject = Factory :access_point, :stop_area => commercial_stop_point
      link = Factory :access_link, :access_point => subject, :stop_area => commercial_stop_point
      subject.generic_access_link_matrix.each do |link|
        if link.link_key.start_with?"A_" 
          link.id.should_not be_nil
        else
          link.id.should be_nil
        end  
      end
    end
  end

  describe "#detail_access_link_matrix" do
    it "should have 4 detail_access_links in matrix" do
      stop_place = Factory :stop_area, :area_type => "StopPlace" 
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" ,:parent => stop_place
      quay1 = Factory :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      quay2 = Factory :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      subject = Factory :access_point, :stop_area => stop_place
      subject.detail_access_link_matrix.size.should == 4
    end
    
    it "should have new detail_access_links in matrix" do
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
      quay = Factory :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      subject = Factory :access_point, :stop_area => commercial_stop_point
      subject.detail_access_link_matrix.each do |link|
        link.id.should be_nil
      end
    end
    it "should have only last detail_access_links as new in matrix" do
      commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
      quay = Factory :stop_area, :parent => commercial_stop_point, :area_type => "Quay"
      subject = Factory :access_point, :stop_area => commercial_stop_point
      link = Factory :access_link, :access_point => subject, :stop_area => quay
      subject.detail_access_link_matrix.each do |link|
        if link.link_key.start_with?"A_" 
          link.id.should_not be_nil
        else
          link.id.should be_nil
        end  
      end
    end
  end

  describe "#coordinates" do
    it "should convert coordinates into latitude/longitude" do
     commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
     subject = Factory :access_point, :stop_area => commercial_stop_point, :coordinates => "45.123,120.456"
     subject.longitude.should be_within(0.001).of(120.456)
     subject.latitude.should be_within(0.001).of(45.123)
   end
    it "should set empty coordinates into nil latitude/longitude" do
     commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
     subject = Factory :access_point, :stop_area => commercial_stop_point, :coordinates => "45.123,120.456"
     subject.longitude.should be_within(0.001).of(120.456)
     subject.latitude.should be_within(0.001).of(45.123)
     subject.coordinates = ""
     subject.save
     subject.longitude.should be_nil
     subject.latitude.should be_nil
   end
    it "should convert latitude/longitude into coordinates" do
     commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
     subject = Factory :access_point, :stop_area => commercial_stop_point, :longitude => 120.456, :latitude => 45.123
     subject.coordinates.should == "45.123,120.456"
   end
    it "should convert nil latitude/longitude into empty coordinates" do
    commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
     subject = Factory :access_point, :stop_area => commercial_stop_point, :longitude => nil, :latitude => nil
     subject.coordinates.should == ""
   end
    it "should accept valid coordinates" do
     commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
     subject = Factory :access_point, :stop_area => commercial_stop_point, :coordinates => "45.123,120.456"
     subject.valid?.should be_true
    end
    it "should accept valid coordinates on limits" do
     commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
     subject = Factory :access_point, :stop_area => commercial_stop_point, :coordinates => "90,180"
     subject.valid?.should be_true
     subject.coordinates = "-90,-180"
     subject.valid?.should be_true
     subject.coordinates = "-90.,180."
     subject.valid?.should be_true
     subject.coordinates = "-90.0,180.00"
     subject.valid?.should be_true
    end
    it "should reject invalid coordinates" do
     commercial_stop_point = Factory :stop_area, :area_type => "CommercialStopPoint" 
     subject = Factory :access_point, :stop_area => commercial_stop_point
     subject.coordinates = ",12"
     subject.valid?.should be_false
     subject.coordinates = "-90"
     subject.valid?.should be_false
     subject.coordinates = "-90.1,180."
     subject.valid?.should be_false
     subject.coordinates = "-90.0,180.1"
     subject.valid?.should be_false
     subject.coordinates = "-91.0,18.1"
     subject.valid?.should be_false
    end
  end
  
end
