require 'geokit'
require 'geo_ruby'

class Chouette::AccessPoint < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  include Geokit::Mappable
  has_many :access_links, :dependent => :destroy
  belongs_to :stop_area
  
  attr_accessor :access_point_type
  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :name, :comment
  attr_accessible :longitude, :latitude, :long_lat_type
  #attr_accessible :x, :y, :projection_type
  attr_accessible :country_code, :street_name
  attr_accessible :openning_time, :closing_time, :access_type, :access_point_type
  attr_accessible :mobility_restricted_suitability, :stairs_availability, :lift_availability
  attr_accessible :stop_area_id
  
  # workaround of ruby 1.8 private method y block attribute y reading access
  #def y
  #  read_attribute :y
  #end

  validates_presence_of :name
  validates_presence_of :access_type

  validates_presence_of :latitude, :if => :longitude
  validates_presence_of :longitude, :if => :latitude
  validates_numericality_of :latitude, :less_than_or_equal_to => 90, :greater_than_or_equal_to => -90, :allow_nil => true
  validates_numericality_of :longitude, :less_than_or_equal_to => 180, :greater_than_or_equal_to => -180, :allow_nil => true

  #validates_presence_of :x, :if => :y
  #validates_presence_of :y, :if => :x
  #validates_numericality_of :x, :allow_nil => true
  #validates_numericality_of :y, :allow_nil => true

  def self.nullable_attributes
    [:street_name, :country_code, :comment, :projection_type, :long_lat_type, :x, :y]
  end

  def to_lat_lng
    Geokit::LatLng.new(latitude, longitude) if latitude and longitude
  end

  def geometry
    GeoRuby::SimpleFeatures::Point.from_lon_lat(longitude, latitude, 4326) if latitude and longitude
  end

  def geometry=(geometry)
    geometry = geometry.to_wgs84
    self.latitude, self.longitude, self.long_lat_type = geometry.lat, geometry.lng, "WGS84"
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
    stop_area.geometry or stop_area.default_position
  end


  def access_point_type
    access_type && Chouette::AccessPointType.new(access_type.underscore)
  end

  def access_point_type=(access_point_type)   
    self.access_type = (access_point_type ? access_point_type.camelcase : nil)
  end

  @@access_point_types = nil
  def self.access_point_types
    @@access_point_types ||= Chouette::AccessPointType.all.select do |access_point_type|
      access_point_type.to_i >= 0
    end
  end

  def generic_access_link_matrix
     matrix = Array.new
     hash = Hash.new
     access_links.each do |link|
        hash[link.link_key] = link
     end
     key=Chouette::AccessLink.build_link_key(self,stop_area,"access_point_to_stop_area")
     if hash.has_key?(key)
       matrix << hash[key]
     else
       link = Chouette::AccessLink.new
       link.access_point = self
       link.stop_area = stop_area
       link.link_orientation_type = "access_point_to_stop_area"
       matrix << link
     end
     key=Chouette::AccessLink.build_link_key(self,stop_area,"stop_area_to_access_point")
     if hash.has_key?(key)
       matrix << hash[key]
     else
       link = Chouette::AccessLink.new
       link.access_point = self
       link.stop_area = stop_area
       link.link_orientation_type = "stop_area_to_access_point"
       matrix << link
     end
     matrix
  end

  def detail_access_link_matrix
     matrix = Array.new
     hash = Hash.new
     access_links.each do |link|
        hash[link.link_key] = link
     end
     stop_area.children_at_base.each do |child|
       key=Chouette::AccessLink.build_link_key(self,child,"access_point_to_stop_area")
       if hash.has_key?(key)
         matrix << hash[key]
       else
         link = Chouette::AccessLink.new
         link.access_point = self
         link.stop_area = child
         link.link_orientation_type = "access_point_to_stop_area"
         matrix << link
       end
       key=Chouette::AccessLink.build_link_key(self,child,"stop_area_to_access_point")
       if hash.has_key?(key)
         matrix << hash[key]
       else
         link = Chouette::AccessLink.new
         link.access_point = self
         link.stop_area = child
         link.link_orientation_type = "stop_area_to_access_point"
         matrix << link
       end
     end
     matrix
  end

end
