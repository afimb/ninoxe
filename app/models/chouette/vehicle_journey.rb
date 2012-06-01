class Chouette::VehicleJourney < Chouette::TridentActiveRecord
  #
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :route
  belongs_to :journey_pattern

  has_many :vehicle_journey_at_stops, :dependent => :destroy, :include => :stop_point, :order => "stop_points.position"
  accepts_nested_attributes_for :vehicle_journey_at_stops

  has_and_belongs_to_many :time_tables, :class_name => 'Chouette::TimeTable', :foreign_key => "vehicle_journey_id", :association_foreign_key => "time_table_id"
  has_many :stop_points, :through => :vehicle_journey_at_stops, :order => 'stop_points.position'
end
