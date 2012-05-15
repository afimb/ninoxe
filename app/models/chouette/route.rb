class Chouette::Route < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :wayback_code
  attr_accessor :direction_code

  belongs_to :line
  has_many :vehicle_journeys, :dependent => :destroy
  has_one :opposite_route, :class_name => 'Chouette::Route'
  has_many :stop_points, :order => 'position', :dependent => :destroy do
    def find_by_stop_area(stop_area)
      stop_area_ids = Integer === stop_area ? [stop_area] : (stop_area.children_in_depth + [stop_area]).map(&:id)
      where( :stopareaid => stop_area_ids).first or
        raise ActiveRecord::RecordNotFound.new("Can't find a StopArea #{stop_area.inspect} in Route #{owner.id.inspect}'s StopPoints")
    end

    def between(departure, arrival)
      between_positions = [departure, arrival].collect do |endpoint|
        case endpoint
        when Chouette::StopArea
          find_by_stop_area(endpoint).position
        when  Chouette::StopPoint
          endpoint.position
        when Integer
          endpoint
        else
          raise ActiveRecord::RecordNotFound.new("Can't determine position in route #{proxy_owner.id} with #{departure.inspect}")
        end        
      end
      where(" position between ? and ? ", between_positions.first, between_positions.last)
    end
  end
  has_many :stop_areas, :through => :stop_points, :order => 'stop_point.position' do
    def between(departure, arrival)
      departure, arrival = [departure, arrival].collect do |endpoint|
        String === endpoint ? Chouette::StopArea.find_by_objectid(endpoint) : endpoint
      end
      proxy_owner.stop_points.between(departure, arrival).includes(:stop_area).collect(&:stop_area)
    end
  end

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
  
  def stop_point_permutation?( stop_point_ids)
    stop_points.map(&:id).sort.join(',') == stop_point_ids.sort.join(',')
  end

  def reorder!( stop_point_ids)
    unless stop_point_permutation?( stop_point_ids)
      raise ArgumentError.new( "New stop point order is not valid, current order #{stop_points.map(&:id).join(',')}, but stop_point_ids received are #{stop_point_ids.join(',')}#")
    end
    
    stop_area_id_by_stop_point_id = {}
    stop_points.each do |sp|
      stop_area_id_by_stop_point_id.merge!( sp.id => sp.stop_area_id)
    end

    reordered_stop_area_ids = []
    stop_point_ids.each do |stop_point_id|
      reordered_stop_area_ids << stop_area_id_by_stop_point_id[ stop_point_id.to_i]
    end

    stop_points.each_with_index do |sp, index|
      if sp.stop_area_id.to_s != reordered_stop_area_ids[ index].to_s
        #result = sp.update_attributes( :stopareaid => reordered_stop_area_ids[ index])
        sp.stop_area_id = reordered_stop_area_ids[ index]
        result = sp.save!
      end
    end
  end
end

