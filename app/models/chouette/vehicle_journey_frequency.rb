module Chouette
  class VehicleJourneyFrequency < VehicleJourney

    after_initialize :fill_journey_category

    has_many :journey_frequencies, dependent: :destroy

    accepts_nested_attributes_for :journey_frequencies, allow_destroy: true

    private

    def fill_journey_category
      self.journey_category = :frequency
    end

  end
end
