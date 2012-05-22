class Chouette::Network < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  
  has_many :lines

  validates_presence_of :registrationnumber
  validates_uniqueness_of :registrationnumber
  validates_format_of :registrationnumber, :with => %r{\A[0-9A-Za-z_-]+\Z}

  def self.object_id_key
    "GroupOfLine"
  end

  def valid?(*args)
    super.tap do |valid|
      errors[:registration_number] = errors[:registrationnumber]
    end
  end

  validates_presence_of :name
  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:line => :network] ]).where(:ptnetwork => {:id => self.id})
  end
  
end

