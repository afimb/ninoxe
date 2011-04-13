class Chouette::TimeTableVehicleJourney < Chouette::ActiveRecord
  set_table_name :timetablevehiclejourney

  belongs_to :time_table, :class_name => "Chouette::TimeTable", :foreign_key => "timetableid"
  belongs_to :vehicle_journeys, :class_name => "Chouette::VehicleJourney", :foreign_key => "vehiclejourneyid"
  
end

