require 'spec_helper'

describe Chouette::TridentActiveRecord do

  subject { Factory(:time_table) }

  describe "#uniq_objectid" do

    it "should rebuild objectid" do
      tm = Factory(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      tm.objectid.should == subject.objectid+"_1"
    end

    it "should rebuild objectid" do
      tm = Factory(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      tm.save
      tm = Factory(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      tm.objectid.should == subject.objectid+"_2"
    end

  end

  describe "#prepare_auto_columns" do

    it "should left objectid" do
      tm = Chouette::TimeTable.new :comment => "merge1" , :objectid => "NINOXE:Timetable:merge1"
      tm.prepare_auto_columns
      tm.objectid.should == "NINOXE:Timetable:merge1"
    end

    it "should add pending_id to objectid" do
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.prepare_auto_columns
      tm.objectid.start_with?("NINOXE:Timetable:__pending_id__").should be_true
    end

    it "should set id to objectid" do
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.save
      tm.objectid.should == "NINOXE:Timetable:"+tm.id.to_s
    end

    it "should detect objectid conflicts" do
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.save
      tm.objectid = "NINOXE:Timetable:"+(tm.id+1).to_s
      tm.save
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.save
      tm.objectid.should == "NINOXE:Timetable:"+tm.id.to_s+"_1"
    end

  end

end


