class Chouette::ConnectionLink < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :link_type_code

  belongs_to :departure, :class_name => 'Chouette::StopArea'
  belongs_to :arrival, :class_name => 'Chouette::StopArea'

  OBJECT_ID_KEY='ConnectionLink'

  validates_presence_of :name
  validates_presence_of :departure
  validates_presence_of :arrival

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

  def self.link_type_binding
    { "UNDERGROUND" => "underground", 
      "MIXED" => "mixed",
      "OVERGROUND" => "overground"}
  end
  def link_type_code
    return nil if self.class.link_type_binding[link_type].nil?
    Chouette::ConnectionLinkType.new( self.class.link_type_binding[link_type])
  end
  def link_type_code=(link_type_code)
    self.link_type = nil
    self.class.link_type_binding.each do |k,v| 
      self.link_type = k if v==link_type_code
    end
  end
  @@link_types = nil
  def self.link_types
    @@link_types ||= Chouette::ConnectionLinkType.all
  end
  
end

