class Chouette::AccessLink < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :access_link_type, :link_orientation_type, :link_key

  attr_accessible :id, :access_link_type,:access_point_id, :stop_area_id
  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :name, :comment
  attr_accessible :link_distance, :link_type, :default_duration, :frequent_traveller_duration, :occasional_traveller_duration
  attr_accessible :mobility_restricted_traveller_duration, :mobility_restricted_suitability, :stairs_availability, :lift_availability, :int_user_needs
  attr_accessible :link_orientation
  attr_accessible :link_orientation_type, :stop_area

  belongs_to :access_point, :class_name => 'Chouette::AccessPoint'
  belongs_to :stop_area, :class_name => 'Chouette::StopArea'

  validates_presence_of :name
  validates_presence_of :link_type
  validates_presence_of :link_orientation

  def access_link_type
    link_type && Chouette::ConnectionLinkType.new(link_type.underscore)
  end

  def access_link_type=(access_link_type)
    self.link_type = (access_link_type ? access_link_type.camelcase : nil)
  end

  @@access_link_types = nil
  def self.access_link_types
    @@access_link_types ||= Chouette::ConnectionLinkType.all
  end

  def link_orientation_type
    link_orientation && Chouette::LinkOrientationType.new(link_orientation.underscore)
  end

  def link_orientation_type=(link_orientation_type)
    self.link_orientation = (link_orientation_type ? link_orientation_type.camelcase : nil)
  end

  @@link_orientation_types = nil
  def self.link_orientation_types
    @@link_orientation_types ||= Chouette::LinkOrientationType.all
  end

  def geometry
    GeoRuby::SimpleFeatures::LineString.from_points( [ access_point.geometry, stop_area.geometry], 4326) if departure.geometry and arrival.geometry
  end

  def link_key
    Chouette::AccessLink.build_link_key(access_point,stop_area,link_orientation_type)
  end
  
  def self.build_link_key(access_point,stop_area,link_orientation_type)
    if link_orientation_type == "access_point_to_stop_area"
      "A_#{access_point.id}-S_#{stop_area.id}"
    else  
      "S_#{stop_area.id}-A_#{access_point.id}"
    end
  end
end

