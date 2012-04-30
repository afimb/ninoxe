class Chouette::ConnectionLink < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :connection_link_type

  belongs_to :departure, :class_name => 'Chouette::StopArea'
  belongs_to :arrival, :class_name => 'Chouette::StopArea'

  OBJECT_ID_KEY='ConnectionLink'

  validates_presence_of :name

  validates_presence_of :objectid
  validates_uniqueness_of :objectid

  validates_numericality_of :objectversion

  def self.objectid_format
    Regexp.new "\\A[0-9A-Za-z_]+:#{model_name}:[0-9A-Za-z_-]+\\Z"
  end
  def self.model_name
    ActiveModel::Name.new Chouette::ConnectionLink, Chouette, "ConnectionLink"
  end
  validates_format_of :objectid, :with => self.objectid_format

  def objectid
    Chouette::ObjectId.new read_attribute(:objectid)
  end

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

  def timestamp_attributes_for_update #:nodoc:
    [:creationtime]
  end
  
  def timestamp_attributes_for_create #:nodoc:
    [:creationtime]
  end

  def connection_link_type
    # return nil if transport_mode_name is nil
    link_type && Chouette::ConnectionLinkType.new( link_type.underscore)
  end

  def connection_link_type=(connection_link_type)
    self.link_type = (connection_link_type ? connection_link_type.camelcase : nil)
  end

  @@connection_link_types = nil
  def self.connection_link_types
    @@connection_link_types ||= Chouette::TransportMode.all
  end

  
end

