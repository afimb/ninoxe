require 'spec_helper'

describe Chouette::Footnote do

  subject { Factory.build(:footnote) }

  it { should validate_presence_of :line }

end
