class Chouette::Network < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  
  has_many :lines

  validates_presence_of :registration_number
  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :version_date, :description, :name, :registration_number, :source_name, :source_type, :source_identifier, :comment

  def self.object_id_key
    "GroupOfLine"
  end

  validates_presence_of :name
  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:line => :network] ]).where(:networks => {:id => self.id})
  end
  
end

