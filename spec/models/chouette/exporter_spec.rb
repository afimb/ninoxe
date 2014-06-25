require 'spec_helper'

describe Chouette::Exporter do

  subject { Chouette::Exporter.new("test") }

  describe "#export" do

    let(:chouette_command) { double :run! => true }

    before(:each) do
      subject.stub :chouette_command => chouette_command
    end

    it "should use specified file in -outputFile option" do
      chouette_command.should_receive(:run!).with(hash_including(:output_file => File.expand_path('file')))
      subject.export "file"
    end
    
    it "should use specified format in -format option" do
      chouette_command.should_receive(:run!).with(hash_including(:format => 'DUMMY'))
      subject.export "file", :format => "dummy"
    end
    
  end

end

