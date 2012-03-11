class Chouette::StopPoint < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :stop_area
  belongs_to :route
  has_many :vehicle_journey_at_stops
  has_many :vehicle_journeys, :through => :vehicle_journey_at_stops, :uniq => true
end
