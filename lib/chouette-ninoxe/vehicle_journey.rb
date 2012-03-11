class Chouette::VehicleJourney < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :route

  has_many :time_table_vehicle_journeys
  has_many :time_tables, :through => :time_table_vehicle_journeys

  belongs_to :journey_pattern

  has_many :vehicle_journey_at_stops
  has_many :stop_points, :through => :vehicle_journey_at_stops
end
