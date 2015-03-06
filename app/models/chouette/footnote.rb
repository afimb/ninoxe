class Chouette::Footnote < Chouette::ActiveRecord
  # attr_accessible :title, :body
  belongs_to :line
  has_and_belongs_to_many :vehicle_journeys, :class_name => 'Chouette::VehicleJourney'

  validates_presence_of :line
end
