require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::Loader do

  let(:schema) { "schema-test"}
  let(:backup_path) { "bck"}
  let(:loader) { Chouette::Loader.new(schema, backup_path)}

  subject { loader}

  describe "#load_chouette_dump" do
    it "should call #drop_chouette before system" do
      loader.should_receive(:drop_chouette).and_raise( Exception.new)
      loader.should_not_receive(:system)
      lambda { loader.load_chouette_dump("titi") }.should raise_error
    end
  end

  describe "#drop_chouette" do
    it "should call #backup_chouette before system" do
      loader.should_receive(:backup_chouette).and_raise( Exception.new)
      loader.should_not_receive(:system)
      lambda { loader.drop_chouette }.should raise_error
    end
  end

  describe "#backup_chouette" do
    context "if #backup_path is nil" do
      before { loader.stub(:backup_path => nil) }
      it "should not call #system" do
        loader.should_not_receive(:system)
        loader.backup_chouette
      end
    end
    context "if #backup_path is not nil" do
      it "should call #system" do
        loader.should_receive(:system)
        loader.backup_chouette
      end
    end
  end

end

