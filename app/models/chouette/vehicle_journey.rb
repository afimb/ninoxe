class Chouette::VehicleJourney < Chouette::TridentActiveRecord
  #
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessible :route_id, :journey_pattern_id, :time_slot_id, :company_id, :objectid, :object_version, :creation_time, :creator_id, :comment, :status_value
  attr_accessible :route, :transport_mode, :published_journey_name, :published_journey_identifier, :facility, :vehicle_type_identifier, :number
  attr_accessible :vehicle_journey_at_stops_attributes, :time_table_tokens, :time_tables
  attr_reader :time_table_tokens

  def self.nullable_attributes
    [:transport_mode, :published_journey_name, :vehicle_type_identifier, :published_journey_identifier, :comment, :status_value]
  end

  belongs_to :company
  belongs_to :route
  belongs_to :journey_pattern

  validates_presence_of :route
  validates_presence_of :journey_pattern

  has_many :vehicle_journey_at_stops, :dependent => :destroy, :include => :stop_point, :order => "stop_points.position"
  accepts_nested_attributes_for :vehicle_journey_at_stops, :allow_destroy => true

  has_and_belongs_to_many :time_tables, :class_name => 'Chouette::TimeTable', :foreign_key => "vehicle_journey_id", :association_foreign_key => "time_table_id"
  has_many :stop_points, :through => :vehicle_journey_at_stops, :order => 'stop_points.position'

  validate :increasing_times
  validates_presence_of :number
  
  before_validation :set_default_values
  def set_default_values
    if number.nil?
      self.number = 0
    end
  end

  def increasing_times
    previous = nil
    vehicle_journey_at_stops.select{|vjas| vjas.departure_time && vjas.arrival_time}.each do |vjas|
      errors.add( :vehicle_journey_at_stops, 'time gap overflow') unless vjas.increasing_times_validate( previous) 
      previous = vjas
    end
  end

  def missing_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
    selected_journey_pattern.stop_points - self.stop_points
  end
  def extra_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
    self.stop_points - selected_journey_pattern.stop_points
  end
  def extra_vjas_in_relation_to_a_journey_pattern(selected_journey_pattern)
    extra_stops = self.extra_stops_in_relation_to_a_journey_pattern(selected_journey_pattern)
    self.vehicle_journey_at_stops.select { |vjas| extra_stops.include?( vjas.stop_point)}
  end
  def time_table_tokens=(ids)
    self.time_table_ids = ids.split(",")
  end
  def bounding_dates
    dates = []

    time_tables.each do |tm|
      tm_bounding_dates = tm.bounding_dates
      unless tm_bounding_dates.empty?
        dates << tm.bounding_dates.min
        dates << tm.bounding_dates.max
      end
    end

    dates.empty? ? [] : [dates.min, dates.max]
  end

  def update_journey_pattern( selected_journey_pattern)
    return unless selected_journey_pattern.route_id==self.route_id

    missing_stops_in_relation_to_a_journey_pattern(selected_journey_pattern).each do |sp|
      self.vehicle_journey_at_stops.build( :stop_point => sp)
    end
    extra_vjas_in_relation_to_a_journey_pattern(selected_journey_pattern).each do |vjas|
      vjas._destroy = true
    end
  end
end
