require 'spec_helper'

describe Chouette::Route do

  subject { Factory(:route) }

  it { should validate_uniqueness_of :objectid }
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }

end
