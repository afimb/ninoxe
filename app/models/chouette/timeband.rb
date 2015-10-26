module Chouette

  class TimebandValidator < ActiveModel::Validator
    def validate(record)
      if record.end_time <= record.start_time
        record.errors[:end_time] << I18n.t('activerecord.errors.models.timeband.start_must_be_before_end')
      end
    end
  end

  class Timeband < Chouette::TridentActiveRecord
    self.primary_key = "id"

    validates :start_time, :end_time, presence: true
    validates_with TimebandValidator

    def self.object_id_key
      "Timeband"
    end
  end

end
