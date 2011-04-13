class Chouette::VehicleJourney < Chouette::ActiveRecord
  set_table_name :vehiclejourney
  belongs_to :route, :class_name => "Chouette::Route", :foreign_key => "routeid"
  has_many :time_table_vehicle_journeys, :class_name => "Chouette::TimeTableVehicleJourney", :foreign_key => "vehiclejourneyid"
  has_many :time_tables, :class_name => "Chouette::TimeTable", :through => :time_table_vehicle_journeys
  has_many :stop_points, :class_name => "Chouette::StopPoint", :through => :vehicle_journey_at_stops
  belongs_to :journey_pattern, :foreign_key => "journeypatternid"
  has_many :vehicle_journey_at_stops, :class_name => "Chouette::VehicleJourneyAtStop", :foreign_key => "vehiclejourneyid"

end
