require 'spec_helper'

describe Chouette::Company do

  subject { Factory(:company) }

  it { should validate_presence_of :registration_number }
  it { should validate_uniqueness_of :registration_number }

  it { should validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { should validate_uniqueness_of :objectid }
  
  describe "#nullables empty" do
    it "should set null empty nullable attributes" do
      subject.organizational_unit = ''
      subject.operating_department_name = ''
      subject.code = ''
      subject.phone = ''
      subject.fax = ''
      subject.email = ''
      subject.nil_if_blank
      subject.organizational_unit.should be_nil
      subject.operating_department_name.should be_nil
      subject.code.should be_nil
      subject.phone.should be_nil
      subject.fax.should be_nil
      subject.email.should be_nil
    end
  end

  describe "#nullables non empty" do
    it "should not set null non epmty nullable attributes" do
      subject.organizational_unit = 'a'
      subject.operating_department_name = 'b'
      subject.code = 'c'
      subject.phone = 'd'
      subject.fax = 'z'
      subject.email = 'r'
      subject.nil_if_blank
      subject.organizational_unit.should_not be_nil
      subject.operating_department_name.should_not be_nil
      subject.code.should_not be_nil
      subject.phone.should_not be_nil
      subject.fax.should_not be_nil
      subject.email.should_not be_nil
    end
  end

end
