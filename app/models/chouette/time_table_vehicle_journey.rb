class Chouette::TimeTableVehicleJourney < Chouette::ActiveRecord
  belongs_to :time_table
  belongs_to :vehicle_journey
end

