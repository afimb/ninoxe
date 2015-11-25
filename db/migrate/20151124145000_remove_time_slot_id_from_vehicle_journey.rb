class RemoveTimeSlotIdFromVehicleJourney < ActiveRecord::Migration
  def up
    remove_column :vehicle_journeys, :time_slot_id
  end
  def down
    add_column :vehicle_journeys, :time_slot_id, "integer", {:limit => 8}
  end
end
