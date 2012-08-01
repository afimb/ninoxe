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
  describe "#bounding_dates" do
    it "should contains min date" do
      min_date = subject.bounding_dates.min
      subject.dates.each do |tm_date|
        (min_date <= tm_date.date).should be_true
      end
      subject.periods.each do |tm_period|
        (min_date <= tm_period.period_start).should be_true
      end

    end
    it "should contains max date" do
      max_date = subject.bounding_dates.max
      subject.dates.each do |tm_date|
        (tm_date.date <= max_date).should be_true
      end
      subject.periods.each do |tm_period|
        (tm_period.period_end <= max_date).should be_true
      end

    end
  end
  describe "#periods" do
    it "should begin with position 0" do
      subject.periods.first.position.should == 0
    end
    context "when first period has been removed" do
      before do
        subject.periods.first.destroy
      end
      it "should begin with position 0" do
        subject.periods.first.position.should == 0
      end
    end
    it "should have period_start before period_end" do
      period = Chouette::TimeTablePeriod.new
      period.period_start = Date.today
      period.period_end = Date.today + 10
      period.valid?.should be_true
    end  
    it "should not have period_start after period_end" do
      period = Chouette::TimeTablePeriod.new
      period.period_start = Date.today
      period.period_end = Date.today - 10
      period.valid?.should be_false
    end  
    it "should not have period_start equal to period_end" do
      period = Chouette::TimeTablePeriod.new
      period.period_start = Date.today
      period.period_end = Date.today
      period.valid?.should be_false
    end  
  end

end
