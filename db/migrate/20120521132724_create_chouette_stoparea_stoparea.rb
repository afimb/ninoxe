class CreateChouetteStopareaStoparea < ActiveRecord::Migration
  def up
    create_table :stopareastoparea, :id => false, :force => true do |t|
      t.integer  "child_id",  :limit => 8
      t.integer  "parent_id", :limit => 8
    end
  end

  def down
    drop_table :stopareastoparea
  end
end
