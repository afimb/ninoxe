class Chouette::Network < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  has_many :lines

  validates_presence_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  validates_presence_of :name

  # attr_accessible :objectid, :object_version, :creation_time, :creator_id, :version_date, :description, :name
  # attr_accessible :registration_number, :source_name, :source_type, :source_identifier, :comment

  def self.object_id_key
    "GroupOfLine"
  end

  def self.nullable_attributes
    [:source_name, :source_type, :source_identifier, :comment]
  end

  def commercial_stop_areas
    Chouette::StopArea.joins(:children => [:stop_points => [:route => [:line => :network] ] ]).where(:networks => {:id => self.id}).uniq
  end

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:line => :network] ]).where(:networks => {:id => self.id})
  end

end

