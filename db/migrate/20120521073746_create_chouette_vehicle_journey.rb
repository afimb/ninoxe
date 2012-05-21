class CreateChouetteVehicleJourney < ActiveRecord::Migration
  def up
    create_table :vehiclejourney, :force => true do |t|
      t.integer  "routeid", :limit => 8
      t.integer  "journeypatternid", :limit => 8
      t.integer  "timeslotid", :limit => 8
      t.integer  "companyid", :limit => 8

      t.string   "objectid"
      t.integer  "objectversion"
      t.datetime "creationtime"
      t.string   "creatorid"

      t.string   "comment"
      t.string   "statusvalue"
      t.string   "transportmode"
      t.string   "publishedjourneyname"
      t.string   "publishedjourneyidentifier"
      t.string   "facility"
      t.string   "vehicletypeidentifier"

      # TODO: delete this column that are here just for chouette-command compliance
      t.integer  "number"
    end
   add_index "vehiclejourney", ["objectid"], :name => "vehiclejourney_objectid_key", :unique => true
   add_index "vehiclejourney", ["routeid"], :name => "index_vehiclejourney_on_routeid"
  end

  def down
   remove_index "vehiclejourney", :name => "vehiclejourney_objectid_key"
   remove_index "vehiclejourney", :name => "index_vehiclejourney_on_routeid"
   drop_table :vehiclejourney
  end
end
