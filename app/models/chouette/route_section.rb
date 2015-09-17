require 'open-uri'
class Chouette::RouteSection < Chouette::TridentActiveRecord
  belongs_to :departure, class_name: 'Chouette::StopArea'
  belongs_to :arrival, class_name: 'Chouette::StopArea'

  validates :departure, :arrival, presence: true
  validates :processed_geometry, presence: true
  DEFAULT_PROCESSOR = proc {|section| section.input_geometry or section.default_geometry.try :to_rgeo}
  def stop_areas
    [departure, arrival].compact
  end

  def default_geometry
    points = stop_areas.collect(&:geometry).compact
    bounds = stop_areas.map do |point|
      {
        lat: point.latitude.to_f,
        lng:point.longitude.to_f
      }
    end
    smart_route(bounds, points)

  end

  def name
    stop_areas.map do |stop_area|
      stop_area.try(:name) or '-'
    end.join(' - ')
  end

  DEFAULT_PROCESSOR = Proc.new { |section| section.input_geometry || section.default_geometry.try(:to_rgeo) }

  @@processor = DEFAULT_PROCESSOR
  cattr_accessor :processor

  def process_geometry
    self.processed_geometry = (processor || DEFAULT_PROCESSOR).call(self)
  end
  before_validation :process_geometry

  def smart_route(bounds, points)
    begin
      response = open "http://router.project-osrm.org/viaroute?loc=#{bounds[0][:lat]},#{bounds[0][:lng]}&loc=#{bounds[1][:lat]},#{bounds[1][:lng]}&instructions=false"
      geometry = JSON.parse(response.read.to_s)['route_geometry']
      decoded_geometry = Polylines::Decoder.decode_polyline(geometry, 1e6).map{|point| GeoRuby::SimpleFeatures::Point.from_x_y(point[1], point[0], 4326)}
      GeoRuby::SimpleFeatures::LineString.from_points(decoded_geometry) if decoded_geometry.many?
    rescue
      logger.info("Failed to add a route for route_section_#{self.id}")
      GeoRuby::SimpleFeatures::LineString.from_points(points) if points.many?
    end
  end

  def editable_geometry=(geometry)
    self.input_geometry = geometry
  end

  def editable_geometry
    input_geometry.try(:to_georuby) or default_geometry
  end

  def editable_geometry_before_type_cast
    editable_geometry.to_ewkt
  end

  def geometry(mode = nil)
    mode ||= :processed
    mode == :editable ? editable_geometry : processed_geometry.to_georuby
  end

end