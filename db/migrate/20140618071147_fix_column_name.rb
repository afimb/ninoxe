class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :lines, :on_demand_transportation, :flexible_service
    rename_column :vehicle_journeys, :on_demand_transportation, :flexible_service
  end

  def down
    rename_column :lines, :flexible_service, :on_demand_transportation
    rename_column :vehicle_journeys, :flexible_service, :on_demand_transportation
  end
end
