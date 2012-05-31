class CreateChouetteVehicleJourneyAtStop < ActiveRecord::Migration
  def up
    create_table :vehiclejourneyatstop, :force => true do |t|
      t.integer  "vehicle_journey_id", :limit => 8
      t.integer  "stop_point_id", :limit => 8

      t.string  "connecting_service_id"
      t.string  "boarding_alighting_possibility"
      
      t.datetime "arrival_time"
      t.datetime "departure_time"
      t.datetime "waiting_time"
      t.datetime "elapse_duration"
      t.datetime "headway_frequency"
    end
   add_index "vehiclejourneyatstop", ["vehicle_journey_id"], :name => "index_vehicle_journey_at_stop_on_vehicle_journey_id"
   add_index "vehiclejourneyatstop", ["stop_point_id"], :name => "index_vehicle_journey_at_stop_on_stop_pointid"
  end

  def down
   remove_index "vehiclejourneyatstop", :name => "index_vehicle_journey_at_stop_on_vehicle_journey_id"
   remove_index "vehiclejourneyatstop", :name => "index_vehicle_journey_at_stop_on_stop_point_id"
   drop_table :vehiclejourneyatstop
  end
end
