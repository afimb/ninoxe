class Chouette::StopPoint < Chouette::ActiveRecord
  set_table_name :stoppoint

  belongs_to :stop_area, :class_name => "Chouette::StopArea", :foreign_key => "stopareaid"
  belongs_to :route, :class_name => "Chouette::Route", :foreign_key => "routeid"
  has_many :vehicle_journey_at_stops, :class_name => "Chouette::VehicleJourneyAtStop", :foreign_key => "stoppointid"
  has_many :vehicle_journeys, :through => :vehicle_journey_at_stops, :uniq => true
  
end
