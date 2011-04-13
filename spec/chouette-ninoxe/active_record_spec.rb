require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::ActiveRecord do

  describe ".potential_config_files" do
    subject { Chouette::ActiveRecord.potential_config_files }
    context "neither RAILS_ROOT or Rails are defined" do
      specify { subject.size == 1}
      specify do 
        File.identical? subject.first, (Pathname.new(__FILE__)+".."+".."+".."+"lib"+"database_chouette.yml").to_s
      end
    end
    context "RAILS_ROOT is defined" do
      before do 
        RAILS_ROOT = "dummy rails env"
      end
      it { should include("dummy rails env/config/database_chouette.yml") }
    end
    context "Rails.root is defined" do
      before do 
        class Rails
          def self.root; "dummy"; end
          def self.env; "dummy"; end
        end 
      end
      it { should include("dummy/config/database_chouette.yml") }
    end
  end

  describe ".config_file" do
    subject { Chouette::ActiveRecord.config_file }
    context "a file does exists among potential config files" do
      let!(:potential_config_files) { ["a","b","c"]}
      before do
        Chouette::ActiveRecord.stub!(:potential_config_files).and_return(potential_config_files)
        File.stub!(:exists?).and_return(false)
        File.should_receive(:exists?).with(potential_config_files.first).and_return(true)
      end
      it { should == "a"}
    end
    context "there is no config file" do
      before do 
        File.stub(:exists? => false)
      end
      it { should be_nil }
    end
  end
  
  describe ".configurations" do
    subject { Chouette::ActiveRecord.configurations }

    # it is very important to begin with this context
    # when Chouette::ActiveRecord.configurations is defined
    # the result is cached
    context ".config is not readable" do
      before do
        Chouette::ActiveRecord.stub(:config_file => "dummy")
      end
      specify { lambda { Chouette::ActiveRecord.configurations }.should raise_error }
    end

    context ".config is defined" do
      let!(:config_content) { <<-eos
                              tata:
                                <%= Chouette.env %>
                              eos
      }
      before(:each) do
        class Rails; def self env; "dummy"; end; end
        IO.stub(:read => config_content)
      end
      it { should == YAML.load( ERB.new( config_content).result) }
    end
  end
  
  describe ".configuration" do
    subject { Chouette::ActiveRecord.configuration }
    let(:configurations) { {:development => :dummy}}
    before { 
      Chouette::ActiveRecord.stub( :configurations => configurations)
    }
    context ".configurations return a hash with expected env" do
      before { Chouette.stub( :env => :development) }
      it { should == :dummy}
    end
    context ".configurations doesn't contain expected env" do
      before { Chouette.stub( :env => :test) }
      it { should be_nil }
    end
  end

end

