require 'spec_helper'

describe Chouette::Loader do

  subject { Chouette::Loader.new("test") }

  before(:each) do
    subject.stub :execute! => true
  end

  describe "#load_dump" do

  end

  describe "#import" do

    before(:each) do
      subject.stub :execute!
    end

    it "should use specified file in -inputFile option" do
      subject.should_receive(:execute!).with(/-inputFile #{File.expand_path('file')}/)
      subject.import "file"
    end
    
    it "should use specified format in -format option" do
      subject.should_receive(:execute!).with(/-format DUMMY/)
      subject.import "file", :format => "dummy"
    end
    
  end

  describe "#create" do
    
    it "should quote schema name" do
      subject.should_receive(:execute!).with(/"test"/)
      subject.create
    end

  end

  describe "#drop" do

    it "should quote schema name" do
      subject.should_receive(:execute!).with(/"test"/)
      subject.drop
    end
    
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

