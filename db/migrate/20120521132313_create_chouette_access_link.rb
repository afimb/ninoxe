class CreateChouetteAccessLink < ActiveRecord::Migration
  def up
    create_table :accesslink, :id => false, :force => true do |t|
      t.integer  "accesspointid", :limit => 8
      t.integer  "stopareaid",    :limit => 8
      t.integer  "arrivalid",     :limit => 8

      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"

      t.string   "name"
      t.string   "comment"
      t.decimal  "linkdistance", :precision => 19, :scale => 2
      t.boolean  "liftavailability"
      t.boolean  "mobilityrestrictedsuitability"
      t.boolean  "stairsavailability"
      t.time     "defaultduration"
      t.time     "frequenttravellerduration"
      t.time     "occasionaltravellerduration"
      t.time     "mobilityrestrictedtravellerduration"

      t.string   "linktype"
      t.integer  "intuserneeds"
      t.string   "linkorientation"
    end
  end

  def down
    drop_table :accesslink
  end
end
