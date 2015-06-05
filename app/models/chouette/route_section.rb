class Chouette::RouteSection < Chouette::TridentActiveRecord
  belongs_to :departure, class_name: 'Chouette::StopArea'
  belongs_to :arrival, class_name: 'Chouette::StopArea'

  validates :departure, :arrival, presence: true
  validates :geometry, presence: true

  def stop_areas
    [departure, arrival].compact
  end

  def default_geometry
    points = stop_areas.collect(&:geometry).compact
    GeoRuby::SimpleFeatures::LineString.from_points(points) if points.many?
  end

  before_validation :set_default_geometry

  def set_default_geometry
    self.geometry = default_geometry.try :to_rgeo
  end

end
