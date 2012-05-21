class CreateChouetteTimeTableVehicleJourney < ActiveRecord::Migration
  def up
    create_table :timetablevehiclejourney, :id => false, :force => true do |t|
      t.integer  "timetableid", :limit => 8
      t.integer  "vehiclejourneyid", :limit => 8
    end
   add_index "timetablevehiclejourney", ["timetableid"], :name => "index_timetablevehiclejourney_on_timetableid"
   add_index "timetablevehiclejourney", ["vehiclejourneyid"], :name => "index_timetablevehiclejourney_on_vehiclejourneyid"
  end

  def down
   remove_index "timetablevehiclejourney", :name => "index_timetablevehiclejourney_on_timetableid"
   remove_index "timetablevehiclejourney", :name => "index_timetablevehiclejourney_on_vehiclejourneyid"
   drop_table :timetablevehiclejourney
  end
end
