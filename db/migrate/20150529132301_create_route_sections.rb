class CreateRouteSections < ActiveRecord::Migration
  def change
    create_table :route_sections do |t|
      t.belongs_to :departure
      t.belongs_to :arrival

      t.line_string :geometry
    end
  end
end
