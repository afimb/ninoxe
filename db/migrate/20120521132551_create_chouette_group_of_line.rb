class CreateChouetteGroupOfLine < ActiveRecord::Migration
  def up
    create_table :groupofline, :force => true do |t|
      t.string   "objectid", :null => false
      t.integer  "object_version"
      t.datetime "creation_time"
      t.string   "creator_id"

      t.string   "name"
      t.string   "comment"
    end
  end

  def down
    drop_table :groupofline
  end
end
