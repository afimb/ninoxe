class Chouette::VehicleJourneyAtStop < Chouette::ActiveRecord
  set_primary_key :id
  
  belongs_to :stop_point
  belongs_to :vehicle_journey

  after_initialize :set_virtual_attributes

  attr_accessor :_destroy
  attr_accessible :vehicle_journey_id, :stop_point_id, :connecting_service_id, :boarding_alighting_possibility, :arrival_time, :departure_time, :waiting_time, :elapse_duration, :headway_frequency, :_destroy, :stop_point

  validate :arrival_must_be_before_departure

  def arrival_must_be_before_departure
    # security against nil values
    return unless arrival_time && departure_time

    if exceeds_gap?( arrival_time, departure_time) 
      errors.add(:arrival_time,I18n.t("activerecord.errors.models.vehicle_journey_at_stop.arrival_must_be_before_departure"))
    end
  end

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
