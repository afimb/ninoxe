class CreateTimeTable < ActiveRecord::Migration
  def up
  create_table "timetable", :force => true do |t|
    t.string   "objectid",      :null => false
    t.integer  "object_version", :default => 1
    t.datetime "creation_time"
    t.string   "creator_id"
    t.string   "version"
    t.string   "comment"
    t.integer  "int_day_types", :default => 0
  end

  add_index "timetable", ["objectid"], :name => "time_table_objectid_key", :unique => true

  create_table "timetable_date", :id => false, :force => true do |t|
    t.integer "time_table_id", :limit => 8, :null => false
    t.date    "date"
    t.integer "position",                 :null => false
  end

  add_index "timetable_date", ["time_table_id"], :name => "index_time_table_date_on_time_table_id"

  create_table "timetable_period", :id => false, :force => true do |t|
    t.integer "time_table_id", :limit => 8, :null => false
    t.date    "period_start"
    t.date    "period_end"
    t.integer "position",                 :null => false
  end

  add_index "timetable_period", ["time_table_id"], :name => "index_time_table_period_on_time_table_id"
  end

  def down
    drop_table "timetable_period"
    drop_table "timetable_date"
    drop_table "timetable"
  end
end
