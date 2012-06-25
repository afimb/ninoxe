require 'spec_helper'

describe Chouette::Network do

  subject { Factory(:network) }

  it { should validate_presence_of :registration_number }
  it { should validate_uniqueness_of :registration_number }

  it { should validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { should validate_uniqueness_of :objectid }

  describe "#stop_areas" do
    let!(:line){Factory(:line, :network => subject)}
    let!(:route){Factory(:route, :line => line)}
    it "should retreive route's stop_areas" do
      subject.stop_areas.count.should == route.stop_points.count
    end
  end
end
