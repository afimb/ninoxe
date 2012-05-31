class CreateChouetteTimeSlot < ActiveRecord::Migration
  def up
    create_table :timeslot, :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.datetime "beginning_slot_time"
      t.datetime "end_slot_time"
      t.datetime "first_departure_time_in_slot"
      t.datetime "last_departure_time_in_slot"
    end
   add_index "timeslot", ["objectid"], :name => "time_slot_objectid_key", :unique => true
  end

  def down
   remove_index "timeslot", :name => "time_slot_objectid_key"
   drop_table :timeslot
  end
end
