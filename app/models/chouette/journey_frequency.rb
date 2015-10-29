module Chouette

  class TimebandConstraintValidator < ActiveModel::Validator
    def validate(record)
      timeband = record.timeband
      if timeband
        if record.first_departure_time.utc.strftime( "%H%M%S%N" ) < timeband.start_time.utc.strftime( "%H%M%S%N" )
          record.errors[:first_departure_time] << I18n.t('activerecord.errors.models.journey_frequency.start_must_be_after_timeband')
        end
        if record.last_departure_time.utc.strftime( "%H%M%S%N" ) > timeband.end_time.utc.strftime( "%H%M%S%N" )
          record.errors[:last_departure_time] << I18n.t('activerecord.errors.models.journey_frequency.end_must_be_before_timeband')
        end
      end
    end
  end

  class JourneyFrequency < ActiveRecord
    belongs_to :vehicle_journey_frequency, foreign_key: 'vehicle_journey_id'
    belongs_to :timeband
    validates :vehicle_journey_id,   presence: true
    validates :first_departure_time, presence: true
    validates :last_departure_time,  presence: true
    validates_with TimebandConstraintValidator
  end
end
