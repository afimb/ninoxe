module Chouette
  class VehicleJourneyFrequency < VehicleJourney

    after_initialize :fill_journey_category

    default_scope { where(journey_category: journey_categories[:frequency]) }

    private

    def fill_journey_category
      self.journey_category = :frequency
    end

  end
end
