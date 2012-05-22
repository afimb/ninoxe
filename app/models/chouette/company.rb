class Chouette::Company < Chouette::TridentActiveRecord
  has_many :lines
  
  validates_presence_of :registrationnumber
  validates_uniqueness_of :registrationnumber
  validates_format_of :registrationnumber, :with => %r{\A[0-9A-Za-z_-]+\Z}

  def valid?(*args)
    super.tap do |valid|
      errors[:registration_number] = errors[:registrationnumber]
    end
  end

  validates_presence_of :name
end

