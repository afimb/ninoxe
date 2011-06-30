require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::StopArea do
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

  describe ".near" do

    let(:stop_area) { Chouette::StopArea.create! :latitude => 1, :longitude => 1 }
    
    it "should find a StopArea at 200m from given origin" do
      Chouette::StopArea.near(stop_area.to_lat_lng.endpoint(0, 0.150, :units => :kms)).should == [stop_area]
    end

    it "should not find a StopArea at more than 200m from given origin" do
      Chouette::StopArea.near(stop_area.to_lat_lng.endpoint(0, 0.250, :units => :kms)).should be_empty
    end

  end

end
