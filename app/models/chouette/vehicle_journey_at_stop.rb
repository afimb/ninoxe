class Chouette::VehicleJourneyAtStop < Chouette::ActiveRecord
  set_primary_key :id
  
  belongs_to :stop_point
  belongs_to :vehicle_journey

  after_initialize :set_virtual_attributes

  attr_accessor :_destroy
  attr_accessible :position, :is_departure, :is_arrival
  attr_accessible :vehicle_journey_id, :stop_point_id, :connecting_service_id, :boarding_alighting_possibility, :arrival_time, :departure_time, :waiting_time, :elapse_duration, :headway_frequency, :_destroy, :stop_point

  def increasing_times_validate( previous)
    result = true
    return result unless previous

    if exceeds_gap?( previous.departure_time, departure_time)
      result = false
      errors.add( :departure_time, 'departure time gap overflow')
    end
    if exceeds_gap?( previous.arrival_time, arrival_time)
      result = false
      errors.add( :arrival_time, 'arrival time gap overflow')
    end
    result
  end
  def exceeds_gap?( first, second)
    3600 < ( ( second-first)%( 3600 * 24))
  end

  def set_virtual_attributes
    @_destroy = false
  end

end
