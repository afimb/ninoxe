require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::ActiveRecord do

  it { Chouette::ActiveRecord.ancestors.should include(ActiveRecord::Base) }

  describe "compute_table_name" do

    it "should return line for Chouette::Line" do
      Chouette::Line.compute_table_name.should == "line"
    end
    
    it "should return ptnetwork for Chouette::Network" do
      Chouette::Network.compute_table_name.should == "ptnetwork"
    end

    it "should return timetable_date for Chouette::TimeTableDate" do
      Chouette::TimeTableDate.compute_table_name.should == "timetable_date"
    end

    it "should return timetable_period for Chouette::TimeTablePeriod" do
      Chouette::TimeTablePeriod.compute_table_name.should == "timetable_period"
    end

  end

  describe "method_missing" do
    
    it "should support method with additionnal underscores" do
      stop_area = Chouette::StopArea.new
      stop_area.area_type.should == stop_area.areatype
    end

  end


  describe "respond_to?" do
    
    it "should respond to method with additionnal underscores" do
      stop_area = Chouette::StopArea.new
      stop_area.respond_to?(area_type).should be_true
    end

  end

  describe "create_reflection" do

    let(:macro) { :has_many }
    let(:name) { :lines }
    let(:options) { {} }
    let(:active_record) { Chouette::Network }
    
    let(:modified_options) { {:modified => true}  }

    it "should invoke create_reflection_without_chouette_naming with modified options" do
      Chouette::ActiveRecord::Reflection.stub :new => mock(:options_with_default => modified_options)
      Chouette::ActiveRecord.should_receive(:create_reflection_without_chouette_naming).with macro, name, modified_options, active_record

      Chouette::ActiveRecord.create_reflection macro, name, options, active_record
    end

  end

end

describe Chouette::ActiveRecord::Inflector do

  subject { Chouette::ActiveRecord::Inflector }

  describe "chouettify" do

    it "should remove underscores" do
      subject.chouettify("without_underscores").should == "withoutunderscores"
    end

    def self.it_should_transform(string, options) 
      expected = options[:into]
      it "should transform #{string} by #{expected}" do
        subject.chouettify(string).should == expected
      end
    end

    it_should_transform "time_table", :into => "timetable"
    it_should_transform "timetableperiod", :into => "timetable_period"
    it_should_transform "timetabledate", :into => "timetable_date"
    it_should_transform "network", :into => "ptnetwork"
    
  end

end

describe Chouette::ActiveRecord::Reflection do

  let(:macro) { :has_many }
  let(:name) { :lines }
  let(:options) { {} }
  let(:active_record) { Chouette::Network }

  subject { Chouette::ActiveRecord::Reflection.new macro, name, options, active_record }

  describe "collection?" do

    it "should be true when macro is has_many" do
      subject.stub :macro => :has_many
      subject.should be_collection
    end

    it "should be false when macro is belongs_to" do
      subject.stub :macro => :belong_to
      subject.should_not be_collection
    end

  end

  describe "class_name" do
    
    it "should be Chouette::Line when name is line" do
      subject.stub :name => "line"
      subject.class_name.should == "Chouette::Line"
    end

    it "should be Chouette::Routes when name is routes and reflection is a collection" do
      subject.stub :name => "routes", :collection? => true
      subject.class_name.should == "Chouette::Route"
    end

  end

  describe "foreign_key_name" do
    
    it "should be ActiveRecord name for collection" do
      subject.stub :collection? => true
      subject.foreign_key_name.should == active_record.name
    end

    it "should be reflection name when not a collection" do
      subject.stub :collection? => false
      subject.foreign_key_name.should == subject.name
    end

  end

  describe "foreign_key" do
    
    it "should be created from foreign_key_name with underscores" do
      subject.stub :foreign_key_name => "DummyForeignKey"
      subject.foreign_key.should == "dummyforeignkeyid"
    end

  end

  describe "options" do
    
    it "should define foreign_key if not" do
      subject.stub :options => {}, :foreign_key => "foreign_key"
      subject.options_with_default[:foreign_key].should == "foreign_key"
    end

    it "should define class_name if not" do
      subject.stub :options => {}, :class_name => "class_name"
      subject.options_with_default[:class_name].should == "class_name"
    end

    it "should not define foreign_key if presents" do
      subject.stub :options => {:foreign_key => "dummy"}
      subject.options_with_default[:foreign_key].should == "dummy"
    end

    it "should not define class_name if presents" do
      subject.stub :options => {:class_name => "dummy"}
      subject.options_with_default[:class_name].should == "dummy"
    end

  end
  

end


