require 'spec_helper'

describe Chouette::TimeTable do

  subject { Factory(:time_table) }

  it { should validate_presence_of :comment }
  it { should validate_uniqueness_of :objectid }

  describe "#dates" do
    it "should begin with position 0" do
      subject.dates.first.position.should == 0
    end
    context "when first date has been removed" do
      before do
        subject.dates.first.destroy
      end
      it "should begin with position 0" do
        subject.dates.first.position.should == 0
      end
    end
  end

end
