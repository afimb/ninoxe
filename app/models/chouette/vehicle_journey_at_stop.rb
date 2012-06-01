class Chouette::VehicleJourneyAtStop < Chouette::ActiveRecord
  belongs_to :stop_point
  belongs_to :vehicle_journey

  attr_accessible :vehicle_journey_id, :stop_point_id, :connecting_service_id, :boarding_alighting_possibility, :arrival_time, :departure_time, :waiting_time, :elapse_duration, :headway_frequency
end
