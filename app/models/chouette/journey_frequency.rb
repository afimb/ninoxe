module Chouette
  class JourneyFrequency < ActiveRecord
    alias_attribute :vehicle_journey_frequency_id, :vehicle_journey_id
    belongs_to :vehicle_journey_frequency
    belongs_to :timeband
    validates :vehicle_journey_id,   presence: true
    validates :first_departure_time, presence: true
    validates :last_departure_time,  presence: true
  end
end
