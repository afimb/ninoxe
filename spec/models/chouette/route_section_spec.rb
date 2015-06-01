require 'spec_helper'

RSpec.describe Chouette::RouteSection, :type => :model do
  it { should validate_presence_of(:departure) }
end
