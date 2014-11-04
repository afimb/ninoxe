class AddGtfsFieldsToStopAreas < ActiveRecord::Migration
  def change
    change_table :stop_areas do |t|
      t.string :url
      t.string :time_zone
    end
  end
end
