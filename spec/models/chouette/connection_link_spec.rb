require 'spec_helper'

describe Chouette::ConnectionLink do
  subject { Factory(:connection_link) }

  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  it { should validate_presence_of :name }

  describe "#connection_link_type" do

    def self.legacy_link_types
      %w{Underground Mixed Overground}
    end
    
    legacy_link_types.each do |link_type|
      context "when link_type is #{link_type}" do
        connection_link_type = Chouette::ConnectionLinkType.new(link_type.underscore)
        it "should be #{connection_link_type}" do
          subject.link_type = link_type
          subject.connection_link_type.should == connection_link_type
        end
      end
    end
    context "when link_type is nil" do
      it "should be nil" do
        subject.link_type = nil
        subject.connection_link_type.should be_nil
      end
    end

  end

  describe "#connection_link_type=" do
    
    it "should change link_type with ConnectionLinkType#name" do
      subject.connection_link_type = "Test"
      subject.link_type.should == "Test"
    end

  end

end
