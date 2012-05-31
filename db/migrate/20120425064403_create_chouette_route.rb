class CreateChouetteRoute < ActiveRecord::Migration
  def up
    create_table "route", :force => true do |t|
      t.integer  "line_id", :limit => 8
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"
      t.string   "name"
      t.string   "comment"
      t.integer   "opposite_route_id", :limit => 8
      t.string   "published_name"
      t.string   "number"
      t.string   "direction"
      t.string   "wayback"
    end
  end

  def down
  end
end
