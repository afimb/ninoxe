class Chouette::VehicleJourney < Chouette::TridentActiveRecord
  #
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessible :route_id, :journey_pattern_id, :time_slot_id, :company_id, :objectid, :object_version, :creation_time, :creator_id, :comment, :status_value, :transport_mode, :published_journey_name, :published_journey_identifier, :facility, :vehicle_type_identifier, :number

  belongs_to :route
  belongs_to :journey_pattern

  has_many :vehicle_journey_at_stops, :dependent => :destroy, :include => :stop_point, :order => "stop_points.position"
  accepts_nested_attributes_for :vehicle_journey_at_stops

  has_and_belongs_to_many :time_tables, :class_name => 'Chouette::TimeTable', :foreign_key => "vehicle_journey_id", :association_foreign_key => "time_table_id"
  has_many :stop_points, :through => :vehicle_journey_at_stops, :order => 'stop_points.position'
end
