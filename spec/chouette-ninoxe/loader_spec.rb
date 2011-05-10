require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::Loader do

  subject { Chouette::Loader.new("test") }

  before(:each) do
    subject.stub :execute! => true
  end

  describe "#load_dump" do

  end

  describe "#drop" do
    
  end

  describe "#backup" do

    let(:file) { "/dev/null" }

    it "should call pg_dump" do
      subject.should_receive(:execute!).with(/^pg_dump/)
      subject.backup file
    end

    it "should dump in specified file" do
      subject.should_receive(:execute!).with(/-f #{file}/)
      subject.backup file
    end
  end

end

