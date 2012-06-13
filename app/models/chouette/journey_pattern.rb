class Chouette::JourneyPattern < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :route
  has_many :vehicle_journeys, :dependent => :destroy
  has_many :vehicle_journey_at_stops, :through => :vehicle_journeys
  has_and_belongs_to_many :stop_points, :class_name => 'Chouette::StopPoint', :order => 'stop_points.position', :before_add => :vjas_add, :before_remove => :vjas_remove, :after_add => :shortcuts_update, :after_remove => :shortcuts_update

  attr_accessible :route_id, :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :registration_number, :published_name, :departure_stop_point_id, :arrival_stop_point_id, :stop_point_ids
  
  def departure_stop_point
    return unless departure_stop_point_id
    Chouette::StopPoint.find( departure_stop_point_id)
  end
  def arrival_stop_point
    return unless arrival_stop_point_id
    Chouette::StopPoint.find( arrival_stop_point_id)
  end

  def geometry
    points = stop_points.includes(:stop_areas).map(&:to_lat_lng).compact.map do |loc|
      [loc.lng, loc.lat]
    end
    GeoRuby::SimpleFeatures::LineString.from_coordinates( points, 4326)
  end
  def shortcuts_update( stop_point)
    self.update_attributes!( :departure_stop_point_id => stop_points.first && stop_points.first.id,
                             :arrival_stop_point_id => stop_points.last && stop_points.last.id)
  end
  def vjas_add( stop_point)
    return if new_record? 

    vehicle_journeys.each do |vj|
      vjas = vj.vehicle_journey_at_stops.create :stop_point_id => stop_point.id 
    end
  end
  def vjas_remove( stop_point)
    return if new_record?

    vehicle_journey_at_stops.where( :stop_point_id => stop_point.id).each do |vjas|
      vjas.destroy
    end
  end
end

