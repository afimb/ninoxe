class Chouette::VehicleJourney < Chouette::TridentActiveRecord
  set_table_name "vehiclejourney"
  #
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :route
  belongs_to :journey_pattern

  has_many :vehicle_journey_at_stops, :dependent => :destroy

  has_and_belongs_to_many :time_tables, :class_name => 'Chouette::TimeTable', :foreign_key => "vehiclejourneyid", :association_foreign_key => "timetableid", :join_table => "timetablevehiclejourney"
  has_many :stop_points, :through => :vehicle_journey_at_stops, :order => 'stoppoint.position'
end
