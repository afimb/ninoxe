module Chouette::Geometry::GeneralPresenter
  def to_line_string_feature( stop_areas)
    points = stop_areas.map(&:to_lat_lng).map do |loc|
      [loc.lng, loc.lat]
    end
    GeoRuby::SimpleFeatures::LineString.from_coordinates( points, 4326)
  end
  def to_multi_point_feature( stop_areas)
    points = stop_areas.map(&:to_lat_lng).compact.map do |loc|
      [loc.lng, loc.lat]
    end
    GeoRuby::SimpleFeatures::MultiPoint.from_coordinates( points, 4326)
  end
  def to_point_feature( stop_area)
    return nil unless stop_area.longitude && stop_area.latitude
    GeoRuby::SimpleFeatures::Point.from_lon_lat( stop_area.longitude, stop_area.latitude, 4326)
  end
end


