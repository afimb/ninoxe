require 'spec_helper'

describe Chouette::TimeTablePeriod do

  let!(:time_table) { Factory(:time_table)}
  subject { Factory(:time_table_period ,:time_table => time_table, :period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,6) ) }
  let!(:p2) {Factory(:time_table_period ,:time_table => time_table, :period_start => Date.new(2014,7,6), :period_end => Date.new(2014,7,14) ) } 

  it { should validate_presence_of :period_start }
  it { should validate_presence_of :period_end }
  
  describe "#overlap" do
    context "when periods intersect, " do
      it "should detect period overlap" do
         subject.overlap?(p2).should be_true
         p2.overlap?(subject).should be_true
      end
    end
    context "when periods don't intersect, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,7)
      end
      it "should not detect period overlap" do
         subject.overlap?(p2).should be_false
         p2.overlap?(subject).should be_false
      end
    end
    context "when period 1 contains period 2, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,1)
        p2.period_end = Date.new(2014,7,6)
      end
      it "should detect period overlap" do
         subject.overlap?(p2).should be_true
         p2.overlap?(subject).should be_true
      end
    end
  end
  describe "#contains" do
    context "when periods intersect, " do
      it "should not detect period inclusion" do
         subject.contains?(p2).should be_false
         p2.contains?(subject).should be_false
      end
    end
    context "when periods don't intersect, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,7)
      end
      it "should not detect period inclusion" do
         subject.contains?(p2).should be_false
         p2.contains?(subject).should be_false
      end
    end
    context "when period 1 contains period 2, " do
      before(:each) do
        p2.period_start = Date.new(2014,7,1)
        p2.period_end = Date.new(2014,7,6)
      end
      it "should detect period inclusion" do
         subject.contains?(p2).should be_true
         p2.contains?(subject).should be_false
      end
    end
  end
end
