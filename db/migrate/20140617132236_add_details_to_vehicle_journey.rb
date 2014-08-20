class AddDetailsToVehicleJourney < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :mobility_restricted_suitability, :boolean
    add_column :vehicle_journeys, :on_demand_transportation, :boolean
  end
end
