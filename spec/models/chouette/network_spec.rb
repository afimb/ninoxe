require 'spec_helper'

describe Chouette::Network, :type => :model do

  subject { Factory(:network) }

  it { is_expected.to validate_presence_of :registration_number }
  it { is_expected.to validate_uniqueness_of :registration_number }

  it { is_expected.to validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { is_expected.to validate_uniqueness_of :objectid }

  describe "#stop_areas" do
    let!(:line){Factory(:line, :network => subject)}
    let!(:route){Factory(:route, :line => line)}
    it "should retreive route's stop_areas" do
      expect(subject.stop_areas.count).to eq(route.stop_points.count)
    end
  end
end
