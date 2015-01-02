require 'spec_helper'

describe Chouette::GroupOfLine, :type => :model do

  subject { Factory(:group_of_line) }

  it { is_expected.to validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { is_expected.to validate_uniqueness_of :objectid }

  describe "#stop_areas" do
    let!(:line){Factory(:line, :group_of_lines => [subject])}
    let!(:route){Factory(:route, :line => line)}
    it "should retreive group of line's stop_areas" do
      expect(subject.stop_areas.count).to eq(route.stop_points.count)
    end
  end
  
  context "#line_tokens=" do
    let!(:line1){Factory(:line)}
    let!(:line2){Factory(:line)}

    it "should return associated line ids" do
      subject.update_attributes :line_tokens => [line1.id, line2.id].join(',')
      expect(subject.lines).to include( line1)
      expect(subject.lines).to include( line2)
    end
  end

end
