require 'spec_helper'

describe Chouette::AccessLink do
  subject { Factory(:access_link) }

  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :link_type }
  it { should validate_presence_of :link_orientation }

  describe "#access_link_type" do

    def self.legacy_link_types
      %w{Underground Mixed Overground}
    end
    
    legacy_link_types.each do |link_type|
      context "when link_type is #{link_type}" do
        access_link_type = Chouette::ConnectionLinkType.new(link_type.underscore)
        it "should be #{access_link_type}" do
          subject.link_type = link_type
          subject.access_link_type.should == access_link_type
        end
      end
    end
  end

  describe "#access_link_type=" do
    
    it "should change link_type with ConnectionLinkType#name" do
      subject.access_link_type = "underground"
      subject.link_type.should == "Underground"
    end

  end

  describe "#link_orientation_type" do

    def self.legacy_link_orientations
      %w{AccessPointToStopArea StopAreaToAccessPoint}
    end
    
    legacy_link_orientations.each do |link_orientation|
      context "when link_orientation is #{link_orientation}" do
        link_orientation_type = Chouette::LinkOrientationType.new(link_orientation.underscore)
        it "should be #{link_orientation_type}" do
          subject.link_orientation = link_orientation
          subject.link_orientation_type.should == link_orientation_type
        end
      end
    end

  end

  describe "#link_orientation_type=" do
    
    it "should change link_orientation with LinkOrientationType#name" do
      subject.link_orientation_type = "access_point_to_stop_area"
      subject.link_orientation.should == "AccessPointToStopArea"
    end

  end

  describe "#link_key" do
    it "should calculate link_key for access to area" do
      subject.link_orientation_type = "access_point_to_stop_area"
      subject.link_key.should == "A_#{subject.access_point.id}-S_#{subject.stop_area.id}"
    end
    it "should calculate link_key for area to access" do
      subject.link_orientation_type = "stop_area_to_access_point"
      subject.link_key.should == "S_#{subject.stop_area.id}-A_#{subject.access_point.id}"
    end
    
  end

end
