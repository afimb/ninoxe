class Chouette::Route < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :wayback_code
  attr_accessor :direction_code

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

  def geometry
    points = stop_areas.map(&:to_lat_lng).compact.map do |loc|
      [loc.lng, loc.lat]
    end
    GeoRuby::SimpleFeatures::LineString.from_coordinates( points, 4326)
  end

  def timestamp_attributes_for_update #:nodoc:
    [:creationtime]
  end
  
  def timestamp_attributes_for_create #:nodoc:
    [:creationtime]
  end

  def self.direction_binding
    { "A" => "straight_forward", 
      "R" => "backward",
      "ClockWise" => "clock_wise",
      "CounterClockWise" => "counter_clock_wise",
      "North" => "north",
      "NorthWest" => "north_west", 
      "West" => "west",
      "SouthWest" => "south_west",
      "South" => "south",
      "SouthEast" => "south_east",
      "East" => "east",
      "NorthEast" => "north_east"}
  end
  def direction_code
    return nil if self.class.direction_binding[direction].nil?
    Chouette::Direction.new( self.class.direction_binding[direction])
  end
  def direction_code=(direction_code)
    self.direction = nil
    self.class.direction_binding.each do |k,v| 
      self.direction = k if v==direction_code
    end
  end
  @@directions = nil
  def self.directions
    @@directions ||= Chouette::Direction.all
  end
  def self.wayback_binding
    { "A" => "straight_forward", "R" => "backward"}
  end
  def wayback_code
    return nil if self.class.wayback_binding[wayback].nil?
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
  
  def stop_areas
    Chouette::StopArea.joins(:stop_points => :route).where(:route => {:id => self.id}).order("stoppoint.position")
  end
end

