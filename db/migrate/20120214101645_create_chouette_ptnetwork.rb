class CreateChouettePtnetwork < ActiveRecord::Migration
  def up
    create_table "ptnetwork", :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.date     "version_date"
      t.string   "description"
      t.string   "name"
      t.string   "registration_number"
      t.string   "source_name"
      t.string   "source_type"
      t.string   "source_identifier"
      t.string   "comment"
    end

    add_index "ptnetwork", ["objectid"], :name => "ptnetwork_objectid_key", :unique => true
    add_index "ptnetwork", ["registration_number"], :name => "ptnetwork_registration_number_key", :unique => true
  end

  def down
  end
end
