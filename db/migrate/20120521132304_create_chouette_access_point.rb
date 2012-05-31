class CreateChouetteAccessPoint < ActiveRecord::Migration
  def up
    create_table :accesspoint, :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.string   "comment"
      t.decimal  "longitude",      :precision => 19, :scale => 16
      t.decimal  "latitude",       :precision => 19, :scale => 16
      t.string   "long_lat_type"
      t.decimal  "x",              :precision => 19, :scale => 2
      t.decimal  "y",              :precision => 19, :scale => 2
      t.string   "projection_type"
      t.string   "country_code"
      t.string   "street_name"
      t.string   "contained_in"

      t.datetime "openningtime"
      t.datetime "closingtime"
      t.string   "type"
      t.boolean  "lift_availability"
      t.datetime "mobility_restricted_suitability"
      t.datetime "stairs_availability"
    end
  end

  def down
    drop_table :accesspoint
  end
end
