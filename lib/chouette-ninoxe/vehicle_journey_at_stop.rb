class Chouette::VehicleJourneyAtStop < Chouette::ActiveRecord
  set_table_name :vehiclejourneyatstop
  belongs_to :stop_point, :class_name => "Chouette::StopPoint", :foreign_key => "stoppointid"
  belongs_to :vehicle_journey, :class_name => "Chouette::VehicleJourney", :foreign_key => "vehiclejourneyid"

end
