class Chouette::StopArea < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  include Geokit::Mappable

  has_many :stop_points, :dependent => :destroy

  validates_presence_of :registrationnumber
  validates_uniqueness_of :registrationnumber
  validates_format_of :registrationnumber, :with => %r{\A[0-9A-Za-z_-]+\Z}, :allow_blank => true

  validates_presence_of :name

  validates_presence_of :objectid
  validates_format_of :objectid, :with => %r{\A[0-9A-Za-z_]+:Line:[0-9A-Za-z_-]+\Z}

  validates_numericality_of :version

  def lines
    self.stop_points.collect(&:route).flatten.collect(&:line).flatten.uniq
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

  def valid?(*args)
    super.tap do |valid|
      errors[:registration_number] = errors[:registrationnumber]
    end
  end

  def timestamp_attributes_for_update #:nodoc:
    [:creationtime]
  end
  
  def timestamp_attributes_for_create #:nodoc:
    [:creationtime]
  end

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
    min_and_max = connection.select_rows("select min(longitude) as min_lon, min(latitude) as min_lat, max(longitude) as max_lon, max(latitude) as max_lat from #{table_name} where latitude is not null and longitude is not null").first
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

  def type
    Chouette::AreaType.new area_type.underscore
  end

  def type=(area_type)
    self.area_type = (area_type ? area_type.name : nil)
  end

  @@types = nil
  def self.types
    @@types ||= Chouette::AreaType.all.select do |area_type|
      area_type.to_i > 0
    end
  end

end
