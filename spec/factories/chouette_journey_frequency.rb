FactoryGirl.define do

  factory :journey_frequency, class: Chouette::JourneyFrequency do
    vehicle_journey_id { 1 }
    timeband
    scheduled_headway_interval { Time.now }
    first_departure_time { timeband.start_time }
    last_departure_time { timeband.end_time }
  end

  factory :journey_frequency_first_departure_time_invalid, class: Chouette::JourneyFrequency do
    vehicle_journey_id { 1 }
    timeband
    scheduled_headway_interval { Time.now }
    first_departure_time { timeband.start_time - 1.minute }
    last_departure_time { timeband.end_time }
  end

  factory :journey_frequency_last_departure_time_invalid, class: Chouette::JourneyFrequency do
    vehicle_journey_id { 1 }
    timeband
    scheduled_headway_interval { Time.now }
    first_departure_time { timeband.start_time }
    last_departure_time { timeband.end_time + 1.minute }
  end

end
