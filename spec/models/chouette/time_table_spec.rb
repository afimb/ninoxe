require 'spec_helper'

describe Chouette::TimeTable do

  subject { Factory(:time_table) }

  it { should validate_presence_of :comment }

  # it { should validate_presence_of :objectid }
  it { should validate_uniqueness_of :objectid }

  describe ".dates" do
    it "should add date at position 0" do
      subject = Factory :time_table 
      subject.dates.create(:date => Date.new(2012,1,10))
      puts " position = #{subject.dates.first.position}"
      subject.dates.first.position.should == 0
    end
  end

end
