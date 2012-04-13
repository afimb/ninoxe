require 'spec_helper'

describe Chouette::TimeTable do

  subject { Factory(:time_table) }

  it { should validate_presence_of :comment }

  # it { should validate_presence_of :objectid }
  it { should validate_uniqueness_of :objectid }


end
