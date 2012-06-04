class Chouette::Company < Chouette::TridentActiveRecord
  has_many :lines
  
  validates_presence_of :registration_number
  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  validates_presence_of :name

  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :name, :short_name, :organizational_unit, :operating_department_name, :code, :phone, :fax, :email, :registration_number
end

