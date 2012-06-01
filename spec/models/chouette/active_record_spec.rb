require 'spec_helper'

describe Chouette::ActiveRecord do

  it { Chouette::ActiveRecord.ancestors.should include(ActiveRecord::Base) }

  describe "table_name" do

    it "should return line for Chouette::Line" do
      Chouette::Line.table_name.should == "lines"
    end
    
    it "should return ptnetwork for Chouette::Network" do
      Chouette::Network.table_name.should == "networks"
    end

    it "should return timetable_date for Chouette::TimeTableDate" do
      Chouette::TimeTableDate.table_name.should == "time_table_dates"
    end

    it "should return timetable_period for Chouette::TimeTablePeriod" do
      Chouette::TimeTablePeriod.table_name.should == "time_table_periods"
    end

  end

  describe "method_missing" do
    
    it "should support method with additionnal underscores" do
      stop_area = Chouette::StopArea.new
      stop_area.area_type.should == stop_area.area_type
    end

  end


  describe "respond_to?" do
    
    it "should respond to method with additionnal underscores" do
      stop_area = Chouette::StopArea.new
      stop_area.respond_to?(:area_type).should be_true
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


  describe "options" do
    
    it "should define class_name if not" do
      subject.stub :options => {}, :class_name => "class_name"
      subject.options_with_default[:class_name].should == "class_name"
    end

    it "should not define class_name if presents" do
      subject.stub :options => {:class_name => "dummy"}
      subject.options_with_default[:class_name].should == "dummy"
    end

  end
  

end


