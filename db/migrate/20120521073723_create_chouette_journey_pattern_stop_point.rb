class CreateChouetteJourneyPatternStopPoint < ActiveRecord::Migration
  def up
    create_table :journeypattern_stoppoint, :id => false, :force => true do |t|
      t.integer  "journeypatternid", :limit => 8
      t.integer  "stoppointid", :limit => 8
    end
    add_index "journeypattern_stoppoint", ["journeypatternid"], :name => "index_journeypatternid_on_journeypattern_stoppoint"
  end

  def down
    remove_index "journeypattern_stoppoint", :name => "index_journeypatternid_on_journeypattern_stoppoint"
    drop_table :journeypattern_stoppoint
  end
end
