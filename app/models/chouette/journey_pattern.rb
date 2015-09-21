class Chouette::JourneyPattern < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  belongs_to :route
  has_many :vehicle_journeys, :dependent => :destroy
  has_many :vehicle_journey_at_stops, :through => :vehicle_journeys
  has_and_belongs_to_many :stop_points, -> { order("stop_points.position") }, :before_add => :vjas_add, :before_remove => :vjas_remove, :after_add => :shortcuts_update_for_add, :after_remove => :shortcuts_update_for_remove
  #has_array_of :route_sections, class_name: 'Chouette::RouteSection'

  #attr_accessible :route_id, :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :registration_number, :published_name, :departure_stop_point_id, :arrival_stop_point_id, :stop_point_ids, :stop_points

  validates_presence_of :route


  # TODO: this a workarround
  # otherwise, we loose the first stop_point
  # when creating a new journey_pattern
  def special_update
    bck_sp = self.stop_points.map {|s| s}
    self.update_attributes :stop_points => []
    self.update_attributes :stop_points => bck_sp
  end

  def departure_stop_point
    return unless departure_stop_point_id
    Chouette::StopPoint.find( departure_stop_point_id)
  end

  def arrival_stop_point
    return unless arrival_stop_point_id
    Chouette::StopPoint.find( arrival_stop_point_id)
  end

  def shortcuts_update_for_add( stop_point)
    stop_points << stop_point unless stop_points.include?( stop_point)

    ordered_stop_points = stop_points
    ordered_stop_points = ordered_stop_points.sort { |a,b| a.position <=> b.position} unless ordered_stop_points.empty?

    self.update_attributes( :departure_stop_point_id => (ordered_stop_points.first && ordered_stop_points.first.id),
                             :arrival_stop_point_id => (ordered_stop_points.last && ordered_stop_points.last.id))
  end

  def shortcuts_update_for_remove( stop_point)
    stop_points.delete( stop_point) if stop_points.include?( stop_point)

    ordered_stop_points = stop_points
    ordered_stop_points = ordered_stop_points.sort { |a,b| a.position <=> b.position} unless ordered_stop_points.empty?

    self.update_attributes( :departure_stop_point_id => (ordered_stop_points.first && ordered_stop_points.first.id),
                             :arrival_stop_point_id => (ordered_stop_points.last && ordered_stop_points.last.id))
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

