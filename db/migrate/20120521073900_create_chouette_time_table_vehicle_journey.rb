class CreateChouetteTimeTableVehicleJourney < ActiveRecord::Migration
  def up
    create_table :timetablevehiclejourney, :id => false, :force => true do |t|
      t.integer  "time_table_id", :limit => 8
      t.integer  "vehicle_journey_id", :limit => 8
    end
   add_index "timetablevehiclejourney", ["time_table_id"], :name => "index_time_table_vehicle_journey_on_time_table_id"
   add_index "timetablevehiclejourney", ["vehicle_journey_id"], :name => "index_time_table_vehicle_journey_on_vehicle_journey_id"
  end

  def down
   remove_index "timetablevehiclejourney", :name => "index_time_table_vehicle_journey_on_time_table_id"
   remove_index "timetablevehiclejourney", :name => "index_time_table_vehicle_journey_on_vehicle_journey_id"
   drop_table :timetablevehiclejourney
  end
end
