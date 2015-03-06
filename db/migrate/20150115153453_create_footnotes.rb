class CreateFootnotes < ActiveRecord::Migration
  def change
    create_table :footnotes do |t|
      t.integer  "line_id", :limit => 8
      t.string :code
      t.string :label

      t.timestamps
    end
  end
end
