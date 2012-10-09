require 'spec_helper'

describe Chouette::GroupOfLine do

  subject { Factory(:group_of_line) }

  it { should validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { should validate_uniqueness_of :objectid }

  describe "#stop_areas" do
    let!(:line){Factory(:line, :group_of_lines => [subject])}
    let!(:route){Factory(:route, :line => line)}
    it "should retreive group of line's stop_areas" do
      subject.stop_areas.count.should == route.stop_points.count
    end
  end
  
  context "#line_tokens=" do
    let!(:line1){Factory(:line)}
    let!(:line2){Factory(:line)}

    it "should return associated line ids" do
      subject.update_attributes :line_tokens => [line1.id, line2.id].join(',')
      subject.lines.should include( line1)
      subject.lines.should include( line2)
    end
  end

end
