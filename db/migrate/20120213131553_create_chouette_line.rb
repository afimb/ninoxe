class CreateChouetteLine < ActiveRecord::Migration
  def up
    create_table "line", :force => true do |t|
      t.integer  "pt_network_id",                :limit => 8
      t.integer  "company_id",                  :limit => 8
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.string   "name"
      t.string   "number"
      t.string   "published_name"
      t.string   "transport_mode_name"
      t.string   "registration_number"
      t.string   "comment"
      t.boolean  "mobility_restricted_suitability"
      t.integer  "int_user_needs"
    end

    add_index "line", ["objectid"], :name => "line_objectid_key", :unique => true
    add_index "line", ["registration_number"], :name => "line_registration_number_key", :unique => true
  end

  def down    
  end
end
