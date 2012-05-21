class CreateChouetteJourneyPattern < ActiveRecord::Migration
  def up
    create_table :journeypattern, :force => true do |t|
      t.integer  "routeid", :limit => 8

      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"

      t.string   "name"
      t.string   "comment"
      t.string   "registrationnumber"
      t.string   "publishedname"
    end
   add_index "journeypattern", ["objectid"], :name => "journeypattern_objectid_key", :unique => true
  end

  def down
   remove_index "journeypattern", :name => "journeypattern_objectid_key"
   drop_table :journeypattern
  end
end
