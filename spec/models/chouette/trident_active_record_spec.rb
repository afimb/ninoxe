require 'spec_helper'

describe Chouette::TridentActiveRecord do

  it { Chouette::TridentActiveRecord.ancestors.should include(Chouette::ActiveRecord) }

  describe "objectid" do

    it "should build automatic objectid when empty" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.save
      g1.objectid.should == "NINOXE:GroupOfLine:"+g1.id.to_s
    end

    it "should build automatic objectid with fixed when only suffix given" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.objectid = "toto"
      g1.save
      g1.objectid.should == "NINOXE:GroupOfLine:toto"
    end
    
    it "should build automatic objectid with extension when already exists" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.save
      cnt = g1.id + 1
      g1.objectid = "NINOXE:GroupOfLine:"+cnt.to_s
      g1.save
      g2 = Chouette::GroupOfLine.new( :name => "g2")
      g2.save
      g2.objectid.should == "NINOXE:GroupOfLine:"+g2.id.to_s+"_1"
    end
    
    it "should build automatic objectid with extension when already exists" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.save
      cnt = g1.id + 2
      g1.objectid = "NINOXE:GroupOfLine:"+cnt.to_s
      g1.save
      g2 = Chouette::GroupOfLine.new( :name => "g2")
      g2.objectid = "NINOXE:GroupOfLine:"+cnt.to_s+"_1"
      g2.save
      g3 = Chouette::GroupOfLine.new( :name => "g3")
      g3.save
      g3.objectid.should == "NINOXE:GroupOfLine:"+g3.id.to_s+"_2"
    end
    
    it "should build automatic objectid when id cleared" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.objectid = "NINOXE:GroupOfLine:xxxx"
      g1.save
      g1.objectid = nil
      g1.save
      g1.objectid.should == "NINOXE:GroupOfLine:"+g1.id.to_s
    end
  end

end


