require 'spec_helper'

describe Chouette::AreaType do
  
  def mode(text_code = "test", numerical_code = nil)
    numerical_code ||= 1 if text_code == "test"
    Chouette::AreaType.new(text_code, numerical_code)
  end

  describe "#to_i" do
    
    it "should return numerical code" do
      mode("test", 1).to_i.should == 1
    end

  end

  it "should return true to #test? when text code is 'test'" do
    mode("test").should be_test
  end

  it "should be equal when text codes are identical" do
    mode("test",1).should == mode("test", 2)
  end

  describe ".new" do

    it "should find numerical code from text code" do
      mode("unknown").to_i.should == 0
    end

    it "should find text code from numerical code" do
      mode(0).should be_unknown
    end

    it "should accept another mode" do
      Chouette::AreaType.new(mode("test")).should == mode("test")
    end
    
  end


  describe ".all" do
    
    Chouette::AreaType.definitions.each do |text_code, numerical_code|
      it "should include a AreaType #{text_code}" do
        Chouette::AreaType.all.should include(Chouette::AreaType.new(text_code))
      end
    end

  end

end
