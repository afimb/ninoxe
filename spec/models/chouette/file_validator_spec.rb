require 'spec_helper'

describe Chouette::FileValidator do

  subject { Chouette::FileValidator.new("public") }

  before(:each) do
    subject.stub :execute! => true
  end


  describe "#validate" do

    let(:chouette_command) { mock :run! => true }

    before(:each) do
      subject.stub :chouette_command => chouette_command
    end

    it "should use specified file in -inputFile option" do
      chouette_command.should_receive(:run!).with(hash_including(:input_file => File.expand_path('file')))
      subject.validate "file"
    end
        
  end

end

