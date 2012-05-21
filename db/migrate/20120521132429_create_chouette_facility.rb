class CreateChouetteFacility < ActiveRecord::Migration
  def up
    create_table :facility, :force => true do |t|
      t.integer  "stopareaid",      :limit => 8
      t.integer  "lineid",          :limit => 8
      t.integer  "connectionlinkid",:limit => 8
      t.integer  "stoppointid",     :limit => 8

      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"

      t.string   "name"
      t.string   "comment"
      t.string   "description"
      t.boolean  "freeaccess"
      t.decimal  "longitude",      :precision => 19, :scale => 16
      t.decimal  "latitude",       :precision => 19, :scale => 16
      t.string   "longlattype"
      t.decimal  "x",              :precision => 19, :scale => 2
      t.decimal  "y",              :precision => 19, :scale => 2
      t.string   "projectiontype"
      t.string   "countrycode"
      t.string   "streetname"
      t.string   "containedin"
    end
  end

  def down
    drop_table :facility
  end
end
