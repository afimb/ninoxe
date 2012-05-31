class CreateChouetteVehicleJourney < ActiveRecord::Migration
  def up
    create_table :vehiclejourney, :force => true do |t|
      t.integer  "route_id", :limit => 8
      t.integer  "journey_pattern_id", :limit => 8
      t.integer  "time_slot_id", :limit => 8
      t.integer  "company_id", :limit => 8

      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "comment"
      t.string   "status_value"
      t.string   "transport_mode"
      t.string   "published_journey_name"
      t.string   "published_journey_identifier"
      t.string   "facility"
      t.string   "vehicle_type_identifier"

      # TODO: delete this column that are here just for chouette-command compliance
      t.integer  "number"
    end
   add_index "vehiclejourney", ["objectid"], :name => "vehicle_journey_objectid_key", :unique => true
   add_index "vehiclejourney", ["route_id"], :name => "index_vehicle_journey_on_route_id"
  end

  def down
   remove_index "vehiclejourney", :name => "vehicle_journey_objectid_key"
   remove_index "vehiclejourney", :name => "index_vehicle_journey_on_route_id"
   drop_table :vehiclejourney
  end
end
