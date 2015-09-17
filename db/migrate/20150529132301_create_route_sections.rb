class CreateRouteSections < ActiveRecord::Migration
  def change
    create_table :route_sections do |t|
      t.belongs_to :departure
      t.belongs_to :arrival

      t.line_string :input_geometry, srid: 4326
      t.line_string :processed_geometry, srid: 4326

      t.string   :objectid, null: false
      t.integer  :object_version
      t.datetime :creation_time
      t.string   :creator_id
    end
  end
end