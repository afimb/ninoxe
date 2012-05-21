class CreateChouetteGroupOfLine < ActiveRecord::Migration
  def up
    create_table :groupofline, :force => true do |t|
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"

      t.string   "name"
      t.string   "comment"
    end
  end

  def down
    drop_table :groupofline
  end
end
