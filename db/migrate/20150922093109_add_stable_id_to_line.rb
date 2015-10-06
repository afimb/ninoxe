class AddStableIdToLine < ActiveRecord::Migration
  def change
    change_table :lines do |t|
      t.string :stable_id
    end
  end
end
