class Chouette::Company < Chouette::ActiveRecord
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

  validates_presence_of :objectid
  validates_uniqueness_of :objectid
  validates_format_of :objectid, :with => %r{\A[0-9A-Za-z_]+:Company:[0-9A-Za-z_-]+\Z}

  def self.model_name
    ActiveModel::Name.new Chouette::Company, Chouette, "Company"
  end

end

