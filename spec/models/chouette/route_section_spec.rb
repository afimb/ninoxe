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

  describe "#process_geometry" do

    let(:sample_geometry) { line_string("0 0,1 1").to_rgeo }

    context "without processor" do

      it "should use the input geometry" do
        subject.input_geometry = sample_geometry
        subject.process_geometry
        expect(subject.processed_geometry).to eq(subject.input_geometry)
      end

      it "should use the default geometry when no input is defined" do
        subject.input_geometry = nil
        subject.process_geometry
        expect(subject.processed_geometry).to eq(subject.default_geometry.to_rgeo)
      end

    end

    context "with a processor" do

      it "should use the processor result" do
        subject.processor = Proc.new { |s| sample_geometry }
        subject.process_geometry
        expect(subject.processed_geometry).to eq(sample_geometry)
      end

    end


  end

end
