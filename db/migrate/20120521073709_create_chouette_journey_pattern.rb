class CreateChouetteJourneyPattern < ActiveRecord::Migration
  def up
    create_table :journeypattern, :force => true do |t|
      t.integer  "route_id", :limit => 8

      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.string   "comment"
      t.string   "registration_number"
      t.string   "published_name"

      t.integer  "departure_stop_point_id", :limit => 8
      t.integer  "arrival_stop_point_id", :limit => 8
    end
   add_index "journeypattern", ["objectid"], :name => "journey_pattern_objectid_key", :unique => true
  end

  def down
   remove_index "journeypattern", :name => "journey_pattern_objectid_key"
   drop_table :journeypattern
  end
end
