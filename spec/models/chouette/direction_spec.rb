require 'spec_helper'

describe Chouette::Direction do

  describe ".new" do
    context "when single argument provided is a direction" do
      let(:text) { "dummy"}
      let(:direction){ Chouette::Direction.new( text, 1)}
      it "should be equals to the provided direction" do
        direction.should == Chouette::Direction.new( direction)
      end
    end
  end

  shared_examples_for "west direction" do
    it "should return true to #west? " do
      direction.should be_west
    end
    context "#to_i" do
      it "should return 6" do
        direction.to_i.should == 6
      end
    end
  end

  context "when instanciating with existing text only ('west' for example)" do
    let(:direction){ Chouette::Direction.new "west"}
    it_should_behave_like "west direction"
  end
  context "when instanciating with existing numerical code only (6 for example)" do
    let(:direction){ Chouette::Direction.new 6}
    it_should_behave_like "west direction"
  end

  context "when instanciating with 'dummy' and 1 as argumrent" do
    let(:text) { "dummy"}
    let(:number) { 1}
    let(:direction){ Chouette::Direction.new( text, number)}

    it "should return true to #dummy? " do
      direction.send( "#{text}?".to_sym).should be_true
    end

    it "should return false to #other-dummy? " do
      direction.send( "other-#{text}?".to_sym).should be_false
    end

    context "#to_i" do
      it "should return provided number" do
        direction.to_i.should == number
      end
    end

    context "#name" do
      it "should return provided text" do
        direction.name.should == text
      end
    end
  end
end
