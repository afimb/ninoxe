class CreateChouetteAccessPoint < ActiveRecord::Migration
  def up
    create_table :accesspoint, :force => true do |t|
      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"

      t.string   "name"
      t.string   "comment"
      t.decimal  "longitude",      :precision => 19, :scale => 16
      t.decimal  "latitude",       :precision => 19, :scale => 16
      t.string   "longlattype"
      t.decimal  "x",              :precision => 19, :scale => 2
      t.decimal  "y",              :precision => 19, :scale => 2
      t.string   "projectiontype"
      t.string   "countrycode"
      t.string   "streetname"
      t.string   "containedin"

      t.datetime "openningtime"
      t.datetime "closingtime"
      t.string   "type"
      t.boolean  "liftavailability"
      t.datetime "mobilityrestrictedsuitability"
      t.datetime "stairsavailability"
    end
  end

  def down
  end
end
