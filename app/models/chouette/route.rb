class Chouette::Route < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :wayback_code

  belongs_to :line
  has_many :stop_points, :order => 'position', :dependent => :destroy
  has_many :stop_areas, :through => :stop_points, :order => 'stoppoint.position' 
  has_many :vehicle_journeys, :dependent => :destroy
  has_one :opposite_route, :class_name => 'Chouette::Route'

  OBJECT_ID_KEY='Route'

  validates_presence_of :name

  validates_presence_of :objectid
  validates_uniqueness_of :objectid

  validates_numericality_of :objectversion

  def self.objectid_format
    Regexp.new "\\A[0-9A-Za-z_]+:#{model_name}:[0-9A-Za-z_-]+\\Z"
  end
  def self.model_name
    ActiveModel::Name.new Chouette::Route, Chouette, "Route"
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

  def self.wayback_binding
    { "A" => "straight_forward", "R" => "backward"}
  end
  def wayback_code
    Chouette::Wayback.new( self.class.wayback_binding[wayback])
  end

  def wayback_code=(wayback_code)
    self.wayback = nil
    self.class.wayback_binding.each do |k,v| 
      self.wayback = k if v==wayback_code
    end
  end

  @@waybacks = nil
  def self.waybacks
    @@waybacks ||= Chouette::Wayback.all
  end
end

