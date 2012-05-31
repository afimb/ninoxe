Factory.define :vehicle_journey_at_stop, :class => "Chouette::VehicleJourneyAtStop" do |vjas|

  vjas.association :vehicle_journey, :factory => :vehicle_journey
end

