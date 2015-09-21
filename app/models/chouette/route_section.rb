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
    GeoRuby::SimpleFeatures::LineString.from_points(points) if points.many?
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

  def process_distance
    self.distance = self.process_geometry.to_georuby.to_wgs84.spherical_distance
  end
  after_validation :process_distance

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
