class Chouette::VehicleJourneyAtStop < Chouette::ActiveRecord
  belongs_to :stop_point
  belongs_to :vehicle_journey

end
