class Chouette::JourneyPatternSection < Chouette::ActiveRecord
  belongs_to :journey_pattern
  belongs_to :route_section

  validates :journey_pattern_id, presence: true
  validates :route_section_id, presence: true
  validates :rank, presence: true, numericality: :only_integer
  validates :journey_pattern_id, uniqueness: { scope: [:route_section_id, :rank] }
end
