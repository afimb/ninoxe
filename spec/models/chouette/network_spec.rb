require 'spec_helper'

describe Chouette::Network do

  subject { Factory(:network) }

  it { should validate_presence_of :registration_number }
  it { should validate_uniqueness_of :registration_number }

  it { should validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { should validate_uniqueness_of :objectid }

end
