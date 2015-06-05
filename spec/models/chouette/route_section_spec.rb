require 'spec_helper'

RSpec.describe Chouette::RouteSection, :type => :model do

  subject { create :route_section }

  it { should validate_presence_of(:departure) }
  it { should validate_presence_of(:arrival) }

  describe "#default_geometry" do

    it "should return nil when departure isn't defined" do
      subject.departure  = nil
      expect(subject.default_geometry).to be_nil
    end

    it "should return nil when arrival isn't defined" do
      subject.arrival  = nil
      expect(subject.default_geometry).to be_nil
    end

    it "should return nil when departure has no geometry" do
      subject.departure.stub :geometry
      expect(subject.default_geometry).to be_nil
    end

    it "should return nil when arrival has no geometry" do
      subject.arrival.stub :geometry
      expect(subject.default_geometry).to be_nil
    end

    it "should use departure geometry as first point" do
      expect(subject.default_geometry.first).to eq(subject.departure.geometry)
    end

  end

end
