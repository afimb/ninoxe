class Chouette::StopArea < Chouette::ActiveRecord
  include Geokit::Mappable

  has_many :stop_points, :dependent => :destroy
  
  def self.commercial
    where :areatype => "CommercialStopPoint"
  end

  def to_lat_lng
    Geokit::LatLng.new(latitude, longitude) if latitude and longitude
  end

  def geometry
    GeoRuby::SimpleFeatures::Point.from_lon_lat(to_lat_lng.lng, to_lat_lng.lat, 4326) if to_lat_lng
  end

  def objectid
    Chouette::ObjectId.new read_attribute(:objectid)
  end

  def self.near(origin, distance = 0.3)
    origin = origin.to_lat_lng

    lat_degree_units = units_per_latitude_degree(:kms)
    lng_degree_units = units_per_longitude_degree(origin.lat, :kms)
    
    where "SQRT(POW(#{lat_degree_units}*(#{origin.lat}-latitude),2)+POW(#{lng_degree_units}*(#{origin.lng}-longitude),2)) <= #{distance}"
  end

end
