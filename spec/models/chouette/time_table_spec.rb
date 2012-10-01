require 'spec_helper'

describe Chouette::TimeTable do

  subject { Factory(:time_table) }

  it { should validate_presence_of :comment }
  it { should validate_uniqueness_of :objectid }

  describe "#valid_days" do
    it "should begin with position 0" do
      subject.int_day_types = 128
      subject.valid_days.should == [6]
    end
  end

  describe "#dates" do
    it "should have with position 0" do
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
  describe "#validity_out_between?" do
    let(:empty_tm) {Factory.build(:time_table)}
    it "should be false if empty calendar" do
      empty_tm.validity_out_between?( Date.today, Date.today + 7.day).should be_false
    end
    it "should be true if caldendar is out during start_date and end_date period" do
      start_date = subject.bounding_dates.max - 2.day
      end_date = subject.bounding_dates.max + 2.day
      subject.validity_out_between?( start_date, end_date).should be_true
    end
    it "should be false if calendar is out on start date" do
      start_date = subject.bounding_dates.max 
      end_date = subject.bounding_dates.max + 2.day
      subject.validity_out_between?( start_date, end_date).should be_false
    end
    it "should be false if calendar is out on end date" do
      start_date = subject.bounding_dates.max - 2.day
      end_date = subject.bounding_dates.max 
      subject.validity_out_between?( start_date, end_date).should be_true
    end
    it "should be false if calendar is out after start_date" do
      start_date = subject.bounding_dates.max + 2.day
      end_date = subject.bounding_dates.max + 4.day
      subject.validity_out_between?( start_date, end_date).should be_false
    end
  end
  describe "#validity_out_from_on?" do
    let(:empty_tm) {Factory.build(:time_table)}
    it "should be false if empty calendar" do
      empty_tm.validity_out_from_on?( Date.today).should be_false
    end
    it "should be true if caldendar ends on expected date" do
      expected_date = subject.bounding_dates.max
      subject.validity_out_from_on?( expected_date).should be_true
    end
    it "should be true if calendar ends before expected date" do
      expected_date = subject.bounding_dates.max + 30.day
      subject.validity_out_from_on?( expected_date).should be_true
    end
    it "should be false if calendars ends after expected date" do
      expected_date = subject.bounding_dates.max - 30.day
      subject.validity_out_from_on?( expected_date).should be_false
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
