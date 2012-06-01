class Chouette::Network < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  
  has_many :lines

  validates_presence_of :registration_number
  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  def self.object_id_key
    "GroupOfLine"
  end

  validates_presence_of :name
  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:routes => [:lines => :networks] ]).where(:networks => {:id => self.id})
  end
  
end

