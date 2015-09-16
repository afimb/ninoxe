require 'open-uri'
class Chouette::RouteSection < Chouette::TridentActiveRecord
  belongs_to :departure, class_name: 'Chouette::StopArea'
  belongs_to :arrival, class_name: 'Chouette::StopArea'

  validates :departure, :arrival, presence: true
  validates :processed_geometry, presence: true

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

    begin
      response = open "http://router.project-osrm.org/viaroute?loc=#{bounds[0][:lat]},#{bounds[0][:lng]}&loc=#{bounds[1][:lat]},#{bounds[1][:lng]}&instructions=false"
      response = JSON.parse(response.read.to_s)
      geometry = response['route_geometry']
      decoded_geometry = Polylines::Decoder.decode_polyline(geometry, 1e6).map{|point| GeoRuby::SimpleFeatures::Point.from_x_y(point[1], point[0], 4326)}
      GeoRuby::SimpleFeatures::LineString.from_points(decoded_geometry) if decoded_geometry.many?
    rescue
      logger.info("Failed to add a route for route_section_#{self.id}")
      GeoRuby::SimpleFeatures::LineString.from_points(points) if points.many?
    end

  end

  def name
    stop_areas.map do |stop_area|
      stop_area.try(:name) or '-'
    end.join(' - ')
  end

  before_validation :process_geometry

  def process_geometry
    self.processed_geometry = (input_geometry or default_geometry.try :to_rgeo)
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
