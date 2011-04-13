require File.expand_path('../spec_helper', __FILE__)

describe Chouette do
  describe ".env" do
    subject { Chouette.env }
    it { should eq "development"}
  end
  describe ".enabled?" do
    subject { Chouette.enabled? }
    it { should be_true }
    it "iuzyeriuyze" do
      puts Chouette::ActiveRecord.configurations.inspect
    end
  end
end
