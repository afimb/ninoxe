require 'spec_helper'

describe Chouette::Geometry::LinePresenter do
  let!(:line) { Factory(:line_with_stop_areas_having_parent) }
  subject { Chouette::Geometry::LinePresenter.new(line)}

  describe "#routes_localized_commercials" do
    it "should return 3 stop_areas" do
      subject.routes_localized_commercials(line.routes.first).size.should == 5
    end
  end
end

