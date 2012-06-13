class Chouette::Route < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :wayback_code
  attr_accessor :direction_code

  attr_accessible :direction_code, :wayback_code, :line_id, :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :opposite_route_id, :published_name, :number, :direction, :wayback

  belongs_to :line

  has_many :journey_patterns, :dependent => :destroy
  has_many :vehicle_journeys, :dependent => :destroy
  has_one :opposite_route, :class_name => 'Chouette::Route', :foreign_key => :opposite_route_id
  has_many :stop_points, :order => 'position', :dependent => :destroy do
    def find_by_stop_area(stop_area)
      stop_area_ids = Integer === stop_area ? [stop_area] : (stop_area.children_in_depth + [stop_area]).map(&:id)
      where( :stop_area_id => stop_area_ids).first or
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
  has_many :stop_areas, :through => :stop_points, :order => 'stop_points.position' do
    def between(departure, arrival)
      departure, arrival = [departure, arrival].collect do |endpoint|
        String === endpoint ? Chouette::StopArea.find_by_objectid(endpoint) : endpoint
      end
      proxy_owner.stop_points.between(departure, arrival).includes(:stop_areas).collect(&:stop_area)
    end
  end

  validates_presence_of :name

  def geometry
    points = stop_areas.map(&:to_lat_lng).compact.map do |loc|
      [loc.lng, loc.lat]
    end
    GeoRuby::SimpleFeatures::LineString.from_coordinates( points, 4326)
  end

  def sorted_vehicle_journeys
    vehicle_journeys.includes( :vehicle_journey_at_stops, :journey_pattern).where( "vehicle_journey_at_stops.stop_point_id=journey_patterns.departure_stop_point_id").order( "vehicle_journey_at_stops.departure_time")
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
    Chouette::StopArea.joins(:stop_points => :route).where(:routes => {:id => self.id}).order("stop_points.position")
  end
  
  def stop_point_permutation?( stop_point_ids)
    stop_points.map(&:id).map(&:to_s).sort == stop_point_ids.map(&:to_s).sort
  end

  def reorder!( stop_point_ids)
    return false unless stop_point_permutation?( stop_point_ids)
    
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
        #result = sp.update_attributes( :stop_area_id => reordered_stop_area_ids[ index])
        sp.stop_area_id = reordered_stop_area_ids[ index]
        result = sp.save!
      end
    end

    return true
  end
end

