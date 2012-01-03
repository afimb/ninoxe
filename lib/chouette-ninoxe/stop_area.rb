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

  def self.bounds
    # Give something like :
    # [["113.5292500000000000", "22.1127580000000000", "113.5819330000000000", "22.2157050000000000"]]
    min_and_max = connection.select_rows("select min(longitude), min(latitude), max(longitude), max(latitude) from #{table_name} where latitude is not null and longitude is not null").first
    return nil unless min_and_max

    # Ignore [nil, nil, nil, nil]
    min_and_max.compact!
    return nil unless min_and_max.size == 4

    min_and_max.collect! { |n| n.to_f }

    # We need something like :
    # [[113.5292500000000000, 22.1127580000000000], [113.5819330000000000, 22.2157050000000000]]
    coordinates = min_and_max.each_slice(2).to_a

    GeoRuby::SimpleFeatures::Envelope.from_coordinates coordinates
  end

end
