class Chouette::Company < Chouette::TridentActiveRecord
  has_many :lines
  
  validates_presence_of :registration_number
  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  validates_presence_of :name
end

