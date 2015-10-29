module Chouette

  class TimebandConstraintValidator < ActiveModel::Validator
    def validate(record)
      timeband = record.timeband
      if timeband
        if record.first_departure_time < timeband.start_time
          record.errors[:first_departure_time] << I18n.t('activerecord.errors.models.journey_frequency.start_must_be_after_timeband')
        end
        if record.last_departure_time > timeband.end_time
          record.errors[:last_departure_time] << I18n.t('activerecord.errors.models.journey_frequency.end_must_be_before_timeband')
        end
      end
    end
  end

  class JourneyFrequency < ActiveRecord
    belongs_to :vehicle_journey
    belongs_to :timeband
    validates :vehicle_journey_id,   presence: true
    validates :first_departure_time, presence: true
    validates :last_departure_time,  presence: true
    validates_with TimebandConstraintValidator
  end
end
