class RemoveProjectionFromStopAreas < ActiveRecord::Migration
  def up
    remove_column :stop_areas, :x
    remove_column :stop_areas, :y
    remove_column :stop_areas, :projection_type
  end

  def down
    add_column :stop_areas, :x, :decimal,:precision => 19, :scale => 2
    add_column :stop_areas, :y, :decimal,:precision => 19, :scale => 2
    add_column :stop_areas, :projection_type, :string
  end
end
