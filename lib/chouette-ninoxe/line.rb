class Chouette::Line < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :company
  belongs_to :network
  has_many :routes, :dependent => :destroy

  def objectid
    Chouette::ObjectId.new read_attribute(:objectid)
  end

  validates_presence_of :network

  validates_presence_of :company

  validates_presence_of :registrationnumber
  validates_uniqueness_of :registrationnumber
  validates_format_of :registrationnumber, :with => %r{\A[0-9A-Za-z_-]+\Z}, :allow_blank => true

  validates_presence_of :name

  validates_presence_of :objectid
  validates_format_of :objectid, :with => %r{\A[0-9A-Za-z_]+:Line:[0-9A-Za-z_-]+\Z}

  validates_numericality_of :version

  def version
    self.objectversion
  end

  def version=(version)
    self.objectversion = version
  end

  before_validation :default_values, :on => :create
  def default_values
    self.version ||= 1
  end

  def transport_mode
    Chouette::TransportMode.new transport_mode_name.underscore
  end

  def transport_mode=(transport_mode)
    self.transport_mode_name = (transport_mode ? transport_mode.name : nil)
  end

  @@transport_modes = nil
  def self.transport_modes
    @@transport_modes ||= Chouette::TransportMode.all.select do |transport_mode|
      transport_mode.to_i >= 0
    end
  end

  def valid?(*args)
    super.tap do |valid|
      errors[:registration_number] = errors[:registrationnumber]
    end
  end

  def timestamp_attributes_for_update #:nodoc:
    [:creationtime]
  end
  
  def timestamp_attributes_for_create #:nodoc:
    [:creationtime]
  end
  
  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => :line]).where(:line => {:id => self.id})
  end

end
