require File.expand_path('../../spec_helper', __FILE__)

describe Chouette::ActiveRecord do
  subject { Chouette::ActiveRecord.ancestors }
  it { should include(ActiveRecord::Base) }
end

