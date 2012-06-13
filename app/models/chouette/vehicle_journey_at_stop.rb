class Chouette::VehicleJourneyAtStop < Chouette::ActiveRecord
  belongs_to :stop_point
  belongs_to :vehicle_journey

  after_initialize :set_virtual_attributes

  attr_accessor :_destroy
  attr_accessible :vehicle_journey_id, :stop_point_id, :connecting_service_id, :boarding_alighting_possibility, :arrival_time, :departure_time, :waiting_time, :elapse_duration, :headway_frequency, :_destroy, :stop_point

  def set_virtual_attributes
    @_destroy = false
  end

end
