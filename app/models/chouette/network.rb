class Chouette::Network < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  OBJECT_ID_KEY='GroupOfLine'
  
  include Chouette::ActiveRecord::ObjectIdManagement

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
  validates_format_of :objectid, :with => %r{\A[0-9A-Za-z_]+:GroupOfLine:[0-9A-Za-z_-]+\Z}

  def self.model_name
    ActiveModel::Name.new Chouette::Network, Chouette, "Network"
  end

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:line => :network] ]).where(:ptnetwork => {:id => self.id})
  end
  
end

