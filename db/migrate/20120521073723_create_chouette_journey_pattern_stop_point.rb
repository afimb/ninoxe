class CreateChouetteJourneyPatternStopPoint < ActiveRecord::Migration
  def up
    create_table :journeypattern_stoppoint, :id => false, :force => true do |t|
      t.integer  "journey_pattern_id", :limit => 8
      t.integer  "stop_point_id", :limit => 8
    end
    add_index "journeypattern_stoppoint", ["journey_pattern_id"], :name => "index_journey_pattern_id_on_journey_pattern_stop_point"
  end

  def down
    remove_index "journeypattern_stoppoint", :name => "index_journey_pattern_id_on_journey_pattern_stop_point"
    drop_table :journeypattern_stoppoint
  end
end
