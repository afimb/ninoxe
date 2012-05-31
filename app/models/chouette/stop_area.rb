require 'geokit'
require 'geo_ruby'

class Chouette::StopArea < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  include Geokit::Mappable
  attr_accessor :stop_area_type
  attr_accessor :children_ids

  has_many :stop_points, :dependent => :destroy

  acts_as_tree :foreign_key => 'parent_id'

  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}, :allow_blank => true
  validates_presence_of :name

  def children_in_depth
    return [] if self.children.empty?

    self.children + self.children.map do |child|
      child.children_in_depth
    end.flatten.compact
  end

  def possible_children
    case area_type
      when "BoardingPosition" then []
      when "Quay" then []
      when "CommercialStopPoint" then Chouette::StopArea.where(:area_type => ['Quay', 'BoardingPosition']) - [self]
      when "StopPlace" then Chouette::StopArea.where(:area_type => ['StopPlace', 'CommercialStopPoint']) - [self]
    end
      
  end

  def possible_parents
    case area_type
      when "BoardingPosition" then Chouette::StopArea.where(:area_type => "CommercialStopPoint")  - [self]
      when "Quay" then Chouette::StopArea.where(:area_type => "CommercialStopPoint") - [self]
      when "CommercialStopPoint" then Chouette::StopArea.where(:area_type => "StopPlace") - [self]
      when "StopPlace" then Chouette::StopArea.where(:area_type => "StopPlace") - [self]
    end
  end

  def lines
    self.stop_points.collect(&:route).flatten.collect(&:line).flatten.uniq
  end

  def self.commercial
    where :area_type => "CommercialStopPoint"
  end

  def to_lat_lng
    Geokit::LatLng.new(latitude, longitude) if latitude and longitude
  end

  def geometry
    GeoRuby::SimpleFeatures::Point.from_lon_lat(to_lat_lng.lng, to_lat_lng.lat, 4326) if to_lat_lng
  end

  def position 
    geometry
  end

  def position=(position)
    position = nil if String === position && position == ""
    position = Geokit::LatLng.normalize(position), 4326 if String === position
    self.latitude = position.lat
    self.longitude = position.lng
  end

  def default_position 
    Chouette::StopArea.bounds.center
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

  def stop_area_type
    area_type && Chouette::AreaType.new(area_type.underscore)
  end

  def stop_area_type=(stop_area_type)   
    self.area_type = (stop_area_type ? stop_area_type.camelcase : nil)
  end

  @@stop_area_types = nil
  def self.stop_area_types
    @@stop_area_types ||= Chouette::AreaType.all.select do |stop_area_type|
      stop_area_type.to_i >= 0
    end
  end

  def children_ids=(children_ids)
    children = children_ids.split(',')
    Chouette::StopArea.find(children).each do |child|
     child.update_attribute :parent_id, self.id
    end
  end

end
