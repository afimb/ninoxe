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

end
