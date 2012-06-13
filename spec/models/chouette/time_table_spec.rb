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
        (tm_period.period_start <= max_date).should be_true
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
  end

end
