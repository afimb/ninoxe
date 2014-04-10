require 'spec_helper'

describe Chouette::TimeTable do

  subject { Factory(:time_table) }

  it { should validate_presence_of :comment }
  it { should validate_uniqueness_of :objectid }

  describe "#periods_max_date" do
    context "when all period extends from 04/10/2013 to 04/15/2013," do
      before(:each) do
        p1 = Chouette::TimeTablePeriod.new( :period_start => Date.strptime("04/10/2013", '%m/%d/%Y'), :period_end => Date.strptime("04/12/2013", '%m/%d/%Y'))
        p2 = Chouette::TimeTablePeriod.new( :period_start => Date.strptime("04/13/2013", '%m/%d/%Y'), :period_end => Date.strptime("04/15/2013", '%m/%d/%Y'))
        subject.periods = [ p1, p2]
        subject.save
      end

      it "should retreive 04/15/2013" do
        subject.periods_max_date.should == Date.strptime("04/15/2013", '%m/%d/%Y')
      end
      context "when day_types select only sunday and saturday," do
        before(:each) do
          # jeudi, vendredi
          subject.update_attributes( :int_day_types => (2**(1+6) + 2**(1+7)))
        end
        it "should retreive 04/14/2013" do
          subject.periods_max_date.should == Date.strptime("04/14/2013", '%m/%d/%Y')
        end
      end
      context "when day_types select only friday," do
        before(:each) do
          # jeudi, vendredi
          subject.update_attributes( :int_day_types => (2**(1+6)))
        end
        it "should retreive 04/12/2013" do
          subject.periods_max_date.should == Date.strptime("04/13/2013", '%m/%d/%Y')
        end
      end
      context "when day_types select only thursday," do
        before(:each) do
          # mardi
          subject.update_attributes( :int_day_types => (2**(1+2)))
        end
        it "should retreive 04/12/2013" do
          # 04/15/2013 is monday !
          subject.periods_max_date.should be_nil
        end
      end
    end
  end
  describe "#periods_min_date" do
    context "when all period extends from 04/10/2013 to 04/15/2013," do
      before(:each) do
        p1 = Chouette::TimeTablePeriod.new( :period_start => Date.strptime("04/10/2013", '%m/%d/%Y'), :period_end => Date.strptime("04/12/2013", '%m/%d/%Y'))
        p2 = Chouette::TimeTablePeriod.new( :period_start => Date.strptime("04/13/2013", '%m/%d/%Y'), :period_end => Date.strptime("04/15/2013", '%m/%d/%Y'))
        subject.periods = [ p1, p2]
        subject.save
      end

      it "should retreive 04/10/2013" do
        subject.periods_min_date.should == Date.strptime("04/10/2013", '%m/%d/%Y')
      end
      context "when day_types select only tuesday and friday," do
        before(:each) do
          # jeudi, vendredi
          subject.update_attributes( :int_day_types => (2**(1+4) + 2**(1+5)))
        end
        it "should retreive 04/11/2013" do
          subject.periods_min_date.should == Date.strptime("04/11/2013", '%m/%d/%Y')
        end
      end
      context "when day_types select only friday," do
        before(:each) do
          # jeudi, vendredi
          subject.update_attributes( :int_day_types => (2**(1+5)))
        end
        it "should retreive 04/12/2013" do
          subject.periods_min_date.should == Date.strptime("04/12/2013", '%m/%d/%Y')
        end
      end
      context "when day_types select only thursday," do
        before(:each) do
          # mardi
          subject.update_attributes( :int_day_types => (2**(1+2)))
        end
        it "should retreive 04/12/2013" do
          # 04/15/2013 is monday !
          subject.periods_min_date.should be_nil
        end
      end
    end
  end
  describe "#periods.build" do
    it "should add a new instance of period, and periods_max_date should not raise error" do
      period = subject.periods.build
      subject.periods_max_date
      period.period_start.should be_nil
      period.period_end.should be_nil
    end
  end
  describe "#periods" do
    context "when a period is added," do
      before(:each) do
        subject.periods << Chouette::TimeTablePeriod.new( :period_start => (subject.bounding_dates.min - 1), :period_end => (subject.bounding_dates.max + 1))
        subject.save
      end
      it "should update shortcut" do
        subject.start_date.should == subject.bounding_dates.min
        subject.end_date.should == subject.bounding_dates.max
      end
    end
    context "when a period is removed," do
      before(:each) do
        subject.dates = []
        subject.periods = []
        subject.periods << Chouette::TimeTablePeriod.new( 
                              :period_start => 4.days.since.to_date, 
                              :period_end => 6.days.since.to_date)
        subject.periods << Chouette::TimeTablePeriod.new( 
                              :period_start => 1.days.since.to_date, 
                              :period_end => 10.days.since.to_date)
        subject.save
        subject.periods = subject.periods - [subject.periods.last]
      end
      def read_tm
        Chouette::TimeTable.find subject.id
      end
      it "should update shortcut" do
        tm = read_tm
        subject.start_date.should == subject.bounding_dates.min
        subject.start_date.should == tm.bounding_dates.min
        subject.start_date.should == 4.days.since.to_date
        subject.end_date.should == subject.bounding_dates.max
        subject.end_date.should == tm.bounding_dates.max
        subject.end_date.should == 6.days.since.to_date
      end
    end
    context "when a period is updated," do
      before(:each) do
        subject.dates = []
        subject.periods = []
        subject.periods << Chouette::TimeTablePeriod.new( 
                              :period_start => 4.days.since.to_date, 
                              :period_end => 6.days.since.to_date)
        subject.periods << Chouette::TimeTablePeriod.new( 
                              :period_start => 1.days.since.to_date, 
                              :period_end => 10.days.since.to_date)
        subject.save
        subject.periods.last.period_end = 15.days.since.to_date
        subject.save
      end
      def read_tm
        Chouette::TimeTable.find subject.id
      end
      it "should update shortcut" do
        tm = read_tm
        subject.start_date.should == subject.bounding_dates.min
        subject.start_date.should == tm.bounding_dates.min
        subject.start_date.should == 1.days.since.to_date
        subject.end_date.should == subject.bounding_dates.max
        subject.end_date.should == tm.bounding_dates.max
        subject.end_date.should == 15.days.since.to_date
      end
    end

  end
  describe "#dates" do
    context "when a date is added," do
      before(:each) do
        subject.dates << Chouette::TimeTableDate.new( :date => (subject.bounding_dates.max + 1))
        subject.save
      end
      it "should update shortcut" do
        subject.start_date.should == subject.bounding_dates.min
        subject.end_date.should == subject.bounding_dates.max
      end
    end
    context "when a date is removed," do
      before(:each) do
        subject.periods = []
        subject.dates = subject.dates - [subject.bounding_dates.max + 1]
      end
      it "should update shortcut" do
        subject.start_date.should == subject.bounding_dates.min
        subject.end_date.should == subject.bounding_dates.max
      end
    end
    context "when all the dates and periods are removed," do
      before(:each) do
        subject.periods = []
        subject.dates = []
      end
      it "should update shortcut" do
        subject.start_date.should be_nil
        subject.end_date.should be_nil
      end
    end
    context "when a date is updated," do
      before(:each) do
        subject.dates = []
        
        subject.periods = []
        subject.periods << Chouette::TimeTablePeriod.new( 
                              :period_start => 4.days.since.to_date, 
                              :period_end => 6.days.since.to_date)
        subject.periods << Chouette::TimeTablePeriod.new( 
                              :period_start => 1.days.since.to_date, 
                              :period_end => 10.days.since.to_date)
        subject.dates << Chouette::TimeTableDate.new( :date => 10.days.since.to_date)
        subject.save
        subject.dates.last.date = 15.days.since.to_date
        subject.save
      end
      def read_tm
        Chouette::TimeTable.find subject.id
      end
      it "should update shortcut" do
        tm = read_tm
        subject.start_date.should == subject.bounding_dates.min
        subject.start_date.should == tm.bounding_dates.min
        subject.start_date.should == 1.days.since.to_date
        subject.end_date.should == subject.bounding_dates.max
        subject.end_date.should == tm.bounding_dates.max
        subject.end_date.should == 15.days.since.to_date
      end
    end
  end

  describe "#valid_days" do
    it "should begin with position 0" do
      subject.int_day_types = 128
      subject.valid_days.should == [6]
    end
  end

  describe "#intersects" do
    it "should return day if a date equal day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1")
      time_table_date = Factory(:time_table_date, :date => Date.today, :time_table_id => time_table.id)
      time_table.intersects([Date.today]).should == [Date.today]
    end

    it "should return [] if a period not include days" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12)
      time_table_period = Factory(:time_table_period, :period_start => Date.new(2013, 05, 27),:period_end =>  Date.new(2013, 05, 30), :time_table_id => time_table.id)
      time_table.intersects([ Date.new(2013, 05, 29),  Date.new(2013, 05, 30)]).should == []
    end

    it "should return days if a period include day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12) # Day type monday and tuesday
      time_table_period = Factory(:time_table_period, :period_start => Date.new(2013, 05, 27),:period_end =>  Date.new(2013, 05, 30), :time_table_id => time_table.id)
      time_table.intersects([ Date.new(2013, 05, 27),  Date.new(2013, 05, 28)]).should == [ Date.new(2013, 05, 27),  Date.new(2013, 05, 28)]
    end

    
  end

  describe "#include_day?" do
    it "should return true if a date equal day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1")
      time_table_date = Factory(:time_table_date, :date => Date.today, :time_table_id => time_table.id)
      time_table.include_day?(Date.today).should == true
    end

    it "should return true if a period include day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12) # Day type monday and tuesday
      time_table_period = Factory(:time_table_period, :period_start => Date.new(2013, 05, 27),:period_end =>  Date.new(2013, 05, 29), :time_table_id => time_table.id)
      time_table.include_day?( Date.new(2013, 05, 27)).should == true
    end
  end

  describe "#include_in_dates?" do
    it "should return true if a date equal day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1")
      time_table_date = Factory(:time_table_date, :date => Date.today, :time_table_id => time_table.id)
      time_table.include_in_dates?(Date.today).should == true
    end
  end
  
  describe "#include_in_periods?" do
    it "should return true if a period include day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 4)
      time_table_period = Factory(:time_table_period, :period_start => Date.new(2012, 1, 1),:period_end => Date.new(2012, 01, 30), :time_table_id => time_table.id)
      time_table.include_in_periods?(Date.new(2012, 1, 2)).should == true
    end
  end

  describe "#include_in_overlap_dates?" do
    it "should return true if a day is included in overlap dates" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 4)
      time_table_period = Factory(:time_table_period, :period_start => Date.new(2012, 1, 1),:period_end => Date.new(2012, 01, 30), :time_table_id => time_table.id)
      time_table_date = Factory(:time_table_date, :date => Date.new(2012, 1, 2), :time_table_id => time_table.id)
      time_table.include_in_overlap_dates?(Date.new(2012, 1, 2)).should == true      
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
    context "when timetable contains only periods" do
      before do
        subject.dates = []
        subject.save
      end
      it "should retreive periods.period_start.min and periods.period_end.max" do
        subject.bounding_dates.min.should == subject.periods.map(&:period_start).min
        subject.bounding_dates.max.should == subject.periods.map(&:period_end).max
      end
    end
    context "when timetable contains only dates" do
      before do
        subject.periods = []
        subject.save
      end
      it "should retreive dates.min and dates.max" do
        subject.bounding_dates.min.should == subject.dates.map(&:date).min
        subject.bounding_dates.max.should == subject.dates.map(&:date).max
      end
    end
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
