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
      context "when 04/15/2013 is excluded, periods_max_dates selects the day before" do
        before(:each) do
          excluded_date = Date.strptime("04/15/2013", '%m/%d/%Y')
          subject.dates = [ Chouette::TimeTableDate.new( :date => excluded_date, :in_out => false)]
          subject.save
        end
        it "should retreive 04/14/2013" do
          subject.periods_max_date.should == Date.strptime("04/14/2013", '%m/%d/%Y')
        end
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

describe "update_attributes on periods and dates" do

    context "update days selection" do
        it "should update start_date and end_end" do
            days_hash = {}.tap do |hash|
                [ :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday ].each { |d| hash[d] = false }
            end
            subject.update_attributes( days_hash)

            read = Chouette::TimeTable.find( subject.id )
            read.start_date.should == read.dates.select{|d| d.in_out}.map(&:date).compact.min
            read.end_date.should == read.dates.select{|d| d.in_out}.map(&:date).compact.max

        end
    end
    context "add a new period" do
        let!( :new_start_date ){ subject.start_date - 20.days }
        let!( :new_end_date ){ subject.end_date + 20.days }
        let!( :new_period_attributes ) {
            pa = periods_attributes
            pa[ "11111111111" ] = { "period_end" => new_end_date, "period_start" => new_start_date, "_destroy" => "", "position" => pa.size.to_s, "id" => "", "time_table_id" => subject.id.to_s}
            pa
        }
        it "should update start_date and end_end" do
            subject.update_attributes( :periods_attributes => new_period_attributes)

            read = Chouette::TimeTable.find( subject.id )
            read.start_date.should == new_start_date
            read.end_date.should == new_end_date
        end
    end
    context "update period end" do
        let!( :new_end_date ){ subject.end_date + 20.days }
        let!( :new_period_attributes ) {
            pa = periods_attributes
            pa[ "0" ].merge! "period_end" => new_end_date
            pa
        }
        it "should update end_date" do
            subject.update_attributes :periods_attributes => new_period_attributes

            read = Chouette::TimeTable.find( subject.id )
            read.end_date.should == new_end_date
        end
    end
    context "update period start" do
        let!( :new_start_date ){ subject.start_date - 20.days }
        let!( :new_period_attributes ) {
            pa = periods_attributes
            pa[ "0" ].merge! "period_start" => new_start_date
            pa
        }
        it "should update start_date" do
            subject.update_attributes :periods_attributes => new_period_attributes

            read = Chouette::TimeTable.find( subject.id )
            read.start_date.should == new_start_date
        end
    end
    context "remove periods and dates and add a new period" do
        let!( :new_start_date ){ subject.start_date + 1.days }
        let!( :new_end_date ){ subject.end_date - 1.days }
        let!( :new_dates_attributes ) {
            da = dates_attributes
            da.each { |k,v| v.merge! "_destroy" => true}
            da
        }
        let!( :new_period_attributes ) {
            pa = periods_attributes
            pa.each { |k,v| v.merge! "_destroy" => true}
            pa[ "11111111111" ] = { "period_end" => new_end_date, "period_start" => new_start_date, "_destroy" => "", "position" => pa.size.to_s, "id" => "", "time_table_id" => subject.id.to_s}
            pa
        }
        it "should update start_date and end_date with new period added" do
            subject.update_attributes :periods_attributes => new_period_attributes, :dates_attributes => new_dates_attributes

            read = Chouette::TimeTable.find( subject.id )
            read.start_date.should == new_start_date
            read.end_date.should == new_end_date
        end
    end
    def dates_attributes
        {}.tap do |hash|
            subject.dates.each_with_index do |p, index|
                hash.merge! index.to_s => p.attributes.merge( "_destroy" => "" )
            end
        end
    end
    def periods_attributes
        {}.tap do |hash|
            subject.periods.each_with_index do |p, index|
                hash.merge! index.to_s => p.attributes.merge( "_destroy" => "" )
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
      context "when 04/10/2013 is excluded, periods_min_dates select the day after" do
        before(:each) do
          excluded_date = Date.strptime("04/10/2013", '%m/%d/%Y')
          subject.dates = [ Chouette::TimeTableDate.new( :date => excluded_date, :in_out => false)]
          subject.save
        end
        it "should retreive 04/11/2013" do
          subject.periods_min_date.should == Date.strptime("04/11/2013", '%m/%d/%Y')
        end
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
        subject.save_shortcuts
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
  describe "#periods.valid?" do
    context "when an empty period is set," do
      it "should not save tm if period invalid" do
        subject = Chouette::TimeTable.new({"comment"=>"test",
                                           "version"=>"",
                                           "monday"=>"0",
                                           "tuesday"=>"0",
                                           "wednesday"=>"0",
                                           "thursday"=>"0",
                                           "friday"=>"0",
                                           "saturday"=>"0",
                                           "sunday"=>"0",
                                           "objectid"=>"",
                                           "periods_attributes"=>{"1397136188334"=>{"period_start"=>"",
                                           "period_end"=>"",
                                           "_destroy"=>""}}})
        subject.save
        subject.id.should be_nil
      end
    end
    context "when a valid period is set," do
      it "it should save tm if period valid" do
        subject = Chouette::TimeTable.new({"comment"=>"test",
                                           "version"=>"",
                                           "monday"=>"1",
                                           "tuesday"=>"1",
                                           "wednesday"=>"1",
                                           "thursday"=>"1",
                                           "friday"=>"1",
                                           "saturday"=>"1",
                                           "sunday"=>"1",
                                           "objectid"=>"",
                                           "periods_attributes"=>{"1397136188334"=>{"period_start"=>"2014-01-01",
                                           "period_end"=>"2015-01-01",
                                           "_destroy"=>""}}})
        subject.save
        tm = Chouette::TimeTable.find subject.id
        tm.periods.empty?.should be_false
        tm.start_date.should == Date.new(2014, 01, 01)
        tm.end_date.should == Date.new(2015, 01, 01)

      end
    end
  end

  describe "#dates" do
    context "when a date is added," do
      before(:each) do
        subject.dates << Chouette::TimeTableDate.new( :date => (subject.bounding_dates.max + 1), :in_out => true)
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
        subject.save_shortcuts
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
        subject.save_shortcuts
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
        subject.dates << Chouette::TimeTableDate.new( :date => 10.days.since.to_date, :in_out => true)
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
  describe "#dates.valid?" do
    it "should not save tm if date invalid" do
      subject = Chouette::TimeTable.new({"comment"=>"test",
                                         "version"=>"",
                                         "monday"=>"0",
                                         "tuesday"=>"0",
                                         "wednesday"=>"0",
                                         "thursday"=>"0",
                                         "friday"=>"0",
                                         "saturday"=>"0",
                                         "sunday"=>"0",
                                         "objectid"=>"",
                                         "dates_attributes"=>{"1397136189216"=>{"date"=>"",
                                         "_destroy"=>"", "in_out" => true}}})
      subject.save
      subject.id.should be_nil
    end
    it "it should save tm if date valid" do
      subject = Chouette::TimeTable.new({"comment"=>"test",
                                         "version"=>"",
                                         "monday"=>"1",
                                         "tuesday"=>"1",
                                         "wednesday"=>"1",
                                         "thursday"=>"1",
                                         "friday"=>"1",
                                         "saturday"=>"1",
                                         "sunday"=>"1",
                                         "objectid"=>"",
                                         "dates_attributes"=>{"1397136189216"=>{"date"=>"2015-01-01",
                                         "_destroy"=>"", "in_out" => true}}})
      subject.save
      tm = Chouette::TimeTable.find subject.id
      tm.dates.empty?.should be_false
      tm.start_date.should == Date.new(2015, 01, 01)
      tm.end_date.should == Date.new(2015, 01, 01)
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
      time_table.dates << Chouette::TimeTableDate.new( :date => Date.today, :in_out => true)
      time_table.intersects([Date.today]).should == [Date.today]
    end

    it "should return [] if a period not include days" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12)
      time_table.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2013, 05, 27),
                              :period_end => Date.new(2013, 05, 30))
      time_table.intersects([ Date.new(2013, 05, 29),  Date.new(2013, 05, 30)]).should == []
    end

    it "should return days if a period include day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12) # Day type monday and tuesday
      time_table.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2013, 05, 27),
                              :period_end => Date.new(2013, 05, 30))
      time_table.intersects([ Date.new(2013, 05, 27),  Date.new(2013, 05, 28)]).should == [ Date.new(2013, 05, 27),  Date.new(2013, 05, 28)]
    end


  end

  describe "#include_day?" do
    it "should return true if a date equal day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1")
      time_table.dates << Chouette::TimeTableDate.new( :date => Date.today, :in_out => true)
      time_table.include_day?(Date.today).should == true
    end

    it "should return true if a period include day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12) # Day type monday and tuesday
      time_table.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2013, 05, 27),
                              :period_end => Date.new(2013, 05, 29))
      time_table.include_day?( Date.new(2013, 05, 27)).should == true
    end
  end

  describe "#include_in_dates?" do
    it "should return true if a date equal day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1")
      time_table.dates << Chouette::TimeTableDate.new( :date => Date.today, :in_out => true)
      time_table.include_in_dates?(Date.today).should == true
    end

    it "should return false if a period include day  but that is exclued" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12) # Day type monday and tuesday
      excluded_date = Date.new(2013, 05, 27)
      time_table.dates << Chouette::TimeTableDate.new( :date => excluded_date, :in_out => false)
      time_table.include_in_dates?( excluded_date).should be_false
    end
  end

  describe "#include_in_periods?" do
    it "should return true if a period include day" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 4)
      time_table.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2012, 1, 1),
                              :period_end => Date.new(2012, 01, 30))
      time_table.include_in_periods?(Date.new(2012, 1, 2)).should == true
    end

    it "should return false if a period include day  but that is exclued" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 12) # Day type monday and tuesday
      excluded_date = Date.new(2013, 05, 27)
      time_table.dates << Chouette::TimeTableDate.new( :date => excluded_date, :in_out => false)
      time_table.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2013, 05, 27),
                              :period_end => Date.new(2013, 05, 29))
      time_table.include_in_periods?( excluded_date).should be_false
    end
  end

  describe "#include_in_overlap_dates?" do
    it "should return true if a day is included in overlap dates" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 4)
      time_table.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2012, 1, 1),
                              :period_end => Date.new(2012, 01, 30))
      time_table.dates << Chouette::TimeTableDate.new( :date => Date.new(2012, 1, 2), :in_out => true)
      time_table.include_in_overlap_dates?(Date.new(2012, 1, 2)).should == true
    end
    it "should return false if the day is excluded" do
      time_table = Chouette::TimeTable.create!(:comment => "Test", :objectid => "test:Timetable:1", :int_day_types => 4)
      time_table.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2012, 1, 1),
                              :period_end => Date.new(2012, 01, 30))
      time_table.dates << Chouette::TimeTableDate.new( :date => Date.new(2012, 1, 2), :in_out => false)
      time_table.include_in_overlap_dates?(Date.new(2012, 1, 2)).should be_false
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

  describe "#effective_days_of_periods" do
      before do
        subject.periods.clear
        subject.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2014, 6, 30),
                              :period_end => Date.new(2014, 7, 6))
        subject.int_day_types = 4|8|16
      end
      it "should return monday to wednesday" do
        subject.effective_days_of_periods.size.should == 3
        subject.effective_days_of_periods[0].should == Date.new(2014, 6, 30)
        subject.effective_days_of_periods[1].should == Date.new(2014, 7, 1)
        subject.effective_days_of_periods[2].should == Date.new(2014, 7, 2)
      end
      it "should return thursday" do
        subject.effective_days_of_periods(Chouette::TimeTable.valid_days(32)).size.should == 1
        subject.effective_days_of_periods(Chouette::TimeTable.valid_days(32))[0].should == Date.new(2014, 7, 3)
      end

  end

  describe "#included_days" do
      before do
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,17), :in_out => false)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,19), :in_out => false)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,20), :in_out => true)
      end
      it "should return 3 dates" do
        days = subject.included_days
        days.size.should == 3
        days[0].should == Date.new(2014, 7, 16)
        days[1].should == Date.new(2014,7, 18)
        days[2].should == Date.new(2014, 7,20)
      end
  end



  describe "#excluded_days" do
      before do
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,17), :in_out => false)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,19), :in_out => false)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,20), :in_out => true)
      end
      it "should return 3 dates" do
        days = subject.excluded_days
        days.size.should == 2
        days[0].should == Date.new(2014, 7, 17)
        days[1].should == Date.new(2014,7, 19)
      end
  end



  describe "#effective_days" do
      before do
        subject.periods.clear
        subject.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2014, 6, 30),
                              :period_end => Date.new(2014, 7, 6))
        subject.int_day_types = 4|8|16
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,1), :in_out => false)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,20), :in_out => true)
      end
      it "should return 5 dates" do
        days = subject.effective_days
        days.size.should == 5
        days[0].should == Date.new(2014, 6, 30)
        days[1].should == Date.new(2014, 7, 2)
        days[2].should == Date.new(2014, 7, 16)
        days[3].should == Date.new(2014, 7, 18)
        days[4].should == Date.new(2014, 7, 20)
      end
  end



  describe "#optimize_periods" do
      before do
        subject.periods.clear
        subject.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2014, 6, 30),
                              :period_end => Date.new(2014, 7, 6))
        subject.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2014, 7, 6),
                              :period_end => Date.new(2014, 7, 14))
        subject.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2014, 6, 1),
                              :period_end => Date.new(2014, 6, 14))
        subject.periods << Chouette::TimeTablePeriod.new(
                              :period_start => Date.new(2014, 6, 3),
                              :period_end => Date.new(2014, 6, 4))
        subject.int_day_types = 4|8|16
      end
      it "should return 2 ordered periods" do
        periods = subject.optimize_periods
        periods.size.should == 2
        periods[0].period_start.should == Date.new(2014, 6, 1)
        periods[0].period_end.should == Date.new(2014, 6, 14)
        periods[1].period_start.should == Date.new(2014, 6, 30)
        periods[1].period_end.should == Date.new(2014, 7, 14)
      end
  end

  describe "#add_included_day" do
      before do
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => false)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,20), :in_out => true)
      end
      it "should do nothing" do
        subject.add_included_day(Date.new(2014,7,16))
        days = subject.included_days
        days.size.should == 2
        days.include?(Date.new(2014,7,16)).should be_true
        days.include?(Date.new(2014,7,18)).should be_false
        days.include?(Date.new(2014,7,20)).should be_true
      end
      it "should switch in_out flag" do
        subject.add_included_day(Date.new(2014,7,18))
        days = subject.included_days
        days.size.should == 3
        days.include?(Date.new(2014,7,16)).should be_true
        days.include?(Date.new(2014,7,18)).should be_true
        days.include?(Date.new(2014,7,20)).should be_true
      end
      it "should add date" do
        subject.add_included_day(Date.new(2014,7,21))
        days = subject.included_days
        days.size.should == 3
        days.include?(Date.new(2014,7,16)).should be_true
        days.include?(Date.new(2014,7,20)).should be_true
        days.include?(Date.new(2014,7,21)).should be_true
      end
  end


  describe "#merge!" do
    context "timetables have periods with common day_types " do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,5))
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,6))
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.int_day_types = 4|16|32|128
        another_tt = Factory(:time_table , :int_day_types => (4|16|64|128) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,5), :period_end => Date.new(2014,8,12))
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,7,15), :period_end => Date.new(2014,7,25))
        subject.merge! another_tt
        subject.reload
      end
      it "should have merged periods" do
        subject.periods.size.should == 3
        subject.periods[0].period_start.should == Date.new(2014, 6, 30)
        subject.periods[0].period_end.should == Date.new(2014, 7, 6)
        subject.periods[1].period_start.should == Date.new(2014, 7, 15)
        subject.periods[1].period_end.should == Date.new(2014, 7, 25)
        subject.periods[2].period_start.should == Date.new(2014, 8, 1)
        subject.periods[2].period_end.should == Date.new(2014, 8, 12)
      end
      it "should have common day_types" do
        subject.int_day_types.should == 4|16|128
      end
      it "should have dates for thursdays and fridays" do
        subject.dates.size.should == 4
        subject.dates[0].date.should == Date.new(2014,7,3)
        subject.dates[1].date.should == Date.new(2014,7,18)
        subject.dates[2].date.should == Date.new(2014,7,25)
        subject.dates[3].date.should == Date.new(2014,8,8)
      end
    end

  end

  describe "#intersect!" do
    context "timetables have periods with common day_types " do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,6))
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,20))
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.int_day_types = 4|16|32|128
        another_tt = Factory(:time_table , :int_day_types => (4|16|64|128) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,6), :period_end => Date.new(2014,8,12))
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,7,15), :period_end => Date.new(2014,7,25))
        subject.intersect! another_tt
        subject.reload
      end
      it "should have 1 common period" do
        subject.periods.size.should == 1
        subject.periods[0].period_start.should == Date.new(2014, 7, 15)
        subject.periods[0].period_end.should == Date.new(2014, 7, 20)
      end
      it "should have common day_types" do
        subject.int_day_types.should == 4|16|128
      end
      it "should have date for period reduced to one day" do
        subject.dates.size.should == 1
        subject.dates[0].date.should == Date.new(2014,8,6)
      end
    end
    context "timetables have periods or dates " do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,17), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,19), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,20), :in_out => true)
        subject.int_day_types = 0
        another_tt = Factory(:time_table , :int_day_types => (4|16|64|128) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,6), :period_end => Date.new(2014,8,12))
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,7,17), :period_end => Date.new(2014,7,25))
        subject.intersect! another_tt
        subject.reload
      end
      it "should have 0 period" do
        subject.periods.size.should == 0
      end
      it "should have merges special flags" do
        subject.int_day_types.should == 0
      end
      it "should have date reduced for period" do
        subject.dates.size.should == 2
        subject.dates[0].date.should == Date.new(2014,7,18)
        subject.dates[1].date.should == Date.new(2014,7,19)
      end
    end
    context "with only periods : intersect timetable have no one day period" do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,6))
        subject.int_day_types = 4|8|16
        another_tt = Factory(:time_table , :int_day_types => (4|8|16) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,6), :period_end => Date.new(2014,8,12))
        subject.intersect! another_tt
        subject.reload
      end
      it "should have 0 result periods" do
        subject.periods.size.should == 0
      end
      it "should have no day_types" do
        subject.int_day_types.should == 0
      end
      it "should have 1 date " do
        subject.dates.size.should == 1
        subject.dates[0].date.should == Date.new(2014,8,6)
      end
    end

  end

  describe "#disjoin!" do
    context "timetables have periods with common day_types " do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,6))
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,20))
        subject.int_day_types = 4|16|32|128
        another_tt = Factory(:time_table , :int_day_types => (4|16|64|128) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,6), :period_end => Date.new(2014,8,12))
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,7,15), :period_end => Date.new(2014,8,2))
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have 2 result periods" do
        subject.periods.size.should == 2
        subject.periods[0].period_start.should == Date.new(2014, 6, 30)
        subject.periods[0].period_end.should == Date.new(2014, 7, 14)
        subject.periods[1].period_start.should == Date.new(2014, 8, 3)
        subject.periods[1].period_end.should == Date.new(2014, 8, 5)
      end
      it "should have remained day_types" do
        subject.int_day_types.should == 4|16|32|128
      end
      it "should have dates for period reduced" do
        subject.dates.size.should == 1
        subject.dates[0].date.should == Date.new(2014,7,17)
      end
    end
    context "timetables have periods or dates " do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,17), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,19), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,20), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,8,6), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,8,7), :in_out => true)
        subject.int_day_types = 0
        another_tt = Factory(:time_table , :int_day_types => (4|16|64|128) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,6), :period_end => Date.new(2014,8,12))
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,7,17), :period_end => Date.new(2014,7,25))
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have 0 period" do
        subject.periods.size.should == 0
      end
      it "should have no remained day_types" do
        subject.int_day_types.should == 0
      end
      it "should have date reduced for period" do
        subject.dates.size.should == 4
        subject.dates[0].date.should == Date.new(2014,7,16)
        subject.dates[1].date.should == Date.new(2014,7,17)
        subject.dates[2].date.should == Date.new(2014,7,20)
        subject.dates[3].date.should == Date.new(2014,8,7)
      end
    end
    context "disjoined timetable have all periods in removed ones " do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,8))
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,20))
        subject.int_day_types = 4|16|32|128
        another_tt = Factory(:time_table , :int_day_types => (4|16|64|128) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,7,31), :period_end => Date.new(2014,8,12))
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,20))
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have 0 result periods" do
        subject.periods.size.should == 0
      end
      it "should have no remained day_types" do
        subject.int_day_types.should == 0
      end
      it "should have dates for period reduced" do
        subject.dates.size.should == 4
        subject.dates[0].date.should == Date.new(2014,7,3)
        subject.dates[1].date.should == Date.new(2014,7,10)
        subject.dates[2].date.should == Date.new(2014,7,17)
        subject.dates[3].date.should == Date.new(2014,8,7)
      end
    end

    context "timetable with dates against timetable with dates and periods" do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,16), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,17), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,19), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,20), :in_out => true)
        subject.int_day_types = 0
        another_tt = Factory(:time_table , :int_day_types => (4|16|64|128) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,7,31), :period_end => Date.new(2014,8,12))
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,17), :in_out => true)
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,18), :in_out => true)
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have 0 result periods" do
        subject.periods.size.should == 0
      end
      it "should have no remained day_types" do
        subject.int_day_types == 0
      end
      it "should have 3 dates left" do
        subject.dates.size.should == 3
        subject.dates[0].date.should == Date.new(2014,7,16)
        subject.dates[1].date.should == Date.new(2014,7,19)
        subject.dates[2].date.should == Date.new(2014,7,20)
      end
    end
    context "timetable with dates against timetable with dates and periods all covered" do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,1), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,2), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,5), :in_out => true)
        subject.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,6), :in_out => true)
        subject.int_day_types = 512
        another_tt = Factory(:time_table , :int_day_types => (32|64|512) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,6,30), :period_end => Date.new(2014,7,11))
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,1), :in_out => true)
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,2), :in_out => true)
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,5), :in_out => true)
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,7,6), :in_out => true)
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have 0 result periods" do
        subject.periods.size.should == 0
      end
      it "should have no remained day_types" do
        subject.int_day_types == 0
      end
      it "should have 0 dates left" do
        subject.dates.size.should == 0
      end
    end

    context "with only periods : disjoined timetable have no empty period" do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,8))
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,10), :period_end => Date.new(2014,8,31))
        subject.int_day_types = 4|8
        another_tt = Factory(:time_table , :int_day_types => (4|8) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,4), :period_end => Date.new(2014,8,7))
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have 1 result periods" do
        subject.periods.size.should == 1
        subject.periods[0].period_start.should == Date.new(2014,8,10)
        subject.periods[0].period_end.should == Date.new(2014,8,31)
      end
      it "should have same day_types" do
        subject.int_day_types.should == 4|8
      end
      it "should have no dates " do
        subject.dates.size.should == 0
      end
    end

    context "with only periods : disjoined timetable have no one day period" do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,6))
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,10), :period_end => Date.new(2014,8,31))
        subject.int_day_types = 4|8|16
        another_tt = Factory(:time_table , :int_day_types => (4|8) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,4), :period_end => Date.new(2014,8,5))
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have 1 result periods" do
        subject.periods.size.should == 1
        subject.periods[0].period_start.should == Date.new(2014,8,10)
        subject.periods[0].period_end.should == Date.new(2014,8,31)
      end
      it "should have same day_types" do
        subject.int_day_types.should == 4|8|16
      end
      it "should have 1 date " do
        subject.dates.size.should == 1
        subject.dates[0].date.should == Date.new(2014,8,6)
      end
    end

    context "with periods against dates: disjoined timetable have no unused excluded date" do
      before do
        subject.periods.clear
        subject.dates.clear
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,1), :period_end => Date.new(2014,8,8))
        subject.periods << Chouette::TimeTablePeriod.new(:period_start => Date.new(2014,8,10), :period_end => Date.new(2014,8,31))
        subject.int_day_types = 4|8|16
        another_tt = Factory(:time_table , :int_day_types => (0) )
        another_tt.periods.clear
        another_tt.dates.clear
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,8,4), :in_out => true)
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,8,5), :in_out => true)
        another_tt.dates << Chouette::TimeTableDate.new( :date => Date.new(2014,8,7), :in_out => true)
        subject.disjoin! another_tt
        subject.reload
      end
      it "should have same 2 result periods" do
        subject.periods.size.should == 2
        subject.periods[0].period_start.should == Date.new(2014,8,1)
        subject.periods[0].period_end.should == Date.new(2014,8,8)
        subject.periods[1].period_start.should == Date.new(2014,8,10)
        subject.periods[1].period_end.should == Date.new(2014,8,31)
      end
      it "should have same day_types" do
        subject.int_day_types.should == 4|8|16
      end
      it "should have only 2 excluded dates " do
        subject.included_days.size.should == 0
        subject.excluded_days.size.should == 2
        subject.excluded_days[0].should == Date.new(2014,8,4)
        subject.excluded_days[1].should == Date.new(2014,8,5)
      end
    end


  end
  describe "#duplicate" do
      it "should be a copy of" do
        target=subject.duplicate
        target.id.should be_nil
        target.comment.should == "Copy of "+subject.comment
        target.objectid.should == subject.objectid+"_1"
        target.int_day_types.should == subject.int_day_types
        target.dates.size.should == subject.dates.size
        target.dates.each do |d|
          d.time_table_id.should be_nil
        end
        target.periods.size.should == subject.periods.size
        target.periods.each do |p|
          p.time_table_id.should be_nil
        end
      end
  end

  describe "#tags" do
      it "should accept tags" do
        subject.tag_list = "toto, titi"
        subject.save
        subject.reload
        Chouette::TimeTable.tag_counts.size.should == 2
        subject.tag_list.size.should == 2
      end
  end

end
