class CreateChouetteVehicleJourneyAtStop < ActiveRecord::Migration
  def up
    create_table :vehiclejourneyatstop, :id => false, :force => true do |t|
      t.integer  "vehiclejourneyid", :limit => 8
      t.integer  "stoppointid", :limit => 8

      t.string  "connectingserviceid"
      t.string  "boardingalightingpossibility"
      
      t.datetime "arrivaltime"
      t.datetime "departuretime"
      t.datetime "waitingtime"
      t.datetime "elapseduration"
      t.datetime "headwayfrequency"

      # TODO: delete this column that are here just for chouette-command compliance
      t.integer  "position"
      t.boolean  "isdeparture"
      t.boolean  "isarrival"
    end
   add_index "vehiclejourneyatstop", ["vehiclejourneyid"], :name => "index_vehiclejourneyatstop_on_vehiclejourneyid"
   add_index "vehiclejourneyatstop", ["stoppointid"], :name => "index_vehiclejourneyatstop_on_stoppointid"
  end

  def down
   remove_index "vehiclejourneyatstop", :name => "index_vehiclejourneyatstop_on_vehiclejourneyid"
   remove_index "vehiclejourneyatstop", :name => "index_vehiclejourneyatstop_on_stoppointid"
   drop_table :vehiclejourneyatstop
  end
end
