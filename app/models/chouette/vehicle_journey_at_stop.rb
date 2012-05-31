class Chouette::VehicleJourneyAtStop < Chouette::ActiveRecord
  set_table_name "vehiclejourneyatstop"

  belongs_to :stop_point
  belongs_to :vehicle_journey

end
