require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::Line do
  its(:objectid) { should be_kind_of(Chouette::ObjectId) }
end
