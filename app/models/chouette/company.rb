class Chouette::Company < Chouette::TridentActiveRecord
  has_many :lines

  validates_presence_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  validates_presence_of :name

  # attr_accessible :objectid, :object_version, :creation_time, :creator_id, :name, :short_name
  # attr_accessible :organizational_unit, :operating_department_name, :code, :phone, :fax, :email, :registration_number
  # attr_accessible :url, :time_zone

  validates_format_of :url, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => true, :allow_blank => true

  def self.nullable_attributes
    [:organizational_unit, :operating_department_name, :code, :phone, :fax, :email, :url, :time_zone]
  end


end

