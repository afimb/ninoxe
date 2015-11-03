require 'spec_helper'

describe Chouette::JourneyFrequency, type: :model do
  describe '#create' do
    context 'when valid' do
      it { create(:journey_frequency) }
    end

    context 'when first_departure_time not valid' do
      it 'fails validation with first_departure_time before timeband start_time' do
        journey_frequency = build(:journey_frequency_first_departure_time_invalid)
        expect(journey_frequency).to be_invalid
      end
    end

    context 'when last_departure_time not valid' do
      it 'fails validation with last_departure_time after timeband end_time' do
        journey_frequency = build(:journey_frequency_last_departure_time_invalid)
        expect(journey_frequency).to be_invalid
      end
    end

    context 'when first and last departure_time not valid' do
      it 'fails validation with first_departure_time equal last_departure_time' do
        journey_frequency = build(:journey_frequency_departure_time_invalid)
        expect(journey_frequency).to be_invalid
      end
    end

    context 'when scheduled_headway_interval not valid' do
      it 'fails validation with scheduled_headway_interval is not set' do
        journey_frequency = build(:journey_frequency_scheduled_headway_interval_invalid)
        expect(journey_frequency).to be_invalid
      end
    end
  end
end
