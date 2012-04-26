require 'spec_helper'

describe Chouette::ConnectionLink do
  subject { Factory(:connection_link) }

  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  it { should validate_presence_of :name }

  it { should validate_presence_of :departure }
  it { should validate_presence_of :arrival }

  describe "#link_type_code" do
    def self.legacy_link_types
      %w{UNDERGROUND MIXED OVERGROUND}
    end
    legacy_link_types.each do |link_type|
      context "when link_type is #{link_type}" do
        link_type_code = Chouette::ConnectionLinkType.new( Chouette::ConnectionLink.link_type_binding[ link_type])
        it "should be #{link_type_code}" do
          subject.link_type = link_type
          subject.link_type_code.should == link_type_code
        end
      end
    end
    context "when link_type is nil" do
      it "should be nil" do
        subject.link_type = nil
        subject.link_type_code.should be_nil
      end
    end
  end
  describe "#link_type_code=" do
    context "when unknown link_type is provided" do
      it "should change link_type to nil" do
        subject.link_type_code = "dummy"
        subject.link_type.should be_nil
      end
    end
    context "when an existing link_type (mixed) is provided" do
      it "should change link_type ConnectionLinkType.mixed" do
        subject.link_type_code = "mixed"
        subject.link_type.should == "MIXED"
      end
    end
  end
end
