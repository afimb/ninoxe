class Chouette::StopPoint < Chouette::ActiveRecord
  belongs_to :stop_area
  belongs_to :route
  has_many :vehicle_journey_at_stops
  has_many :vehicle_journeys, :through => :vehicle_journey_at_stops, :uniq => true
end
