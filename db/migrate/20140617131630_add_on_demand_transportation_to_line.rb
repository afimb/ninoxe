class AddOnDemandTransportationToLine < ActiveRecord::Migration
  def change
    add_column :lines, :on_demand_transportation, :boolean
  end
end
