class Chouette::JourneyPattern < Chouette::ActiveRecord
  set_table_name :journeypattern
  has_many :vehicle_journeys, :foreign_key => "journeypatternid"
end

