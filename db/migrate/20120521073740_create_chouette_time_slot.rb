class CreateChouetteTimeSlot < ActiveRecord::Migration
  def up
    create_table :timeslot, :force => true do |t|
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"

      t.string   "name"
      t.datetime "beginningslottime"
      t.datetime "endslottime"
      t.datetime "firstdeparturetimeinslot"
      t.datetime "lastdeparturetimeinslot"
    end
   add_index "timeslot", ["objectid"], :name => "timeslot_objectid_key", :unique => true
  end

  def down
   remove_index "timeslot", :name => "timeslot_objectid_key"
   drop_table :timeslot
  end
end
