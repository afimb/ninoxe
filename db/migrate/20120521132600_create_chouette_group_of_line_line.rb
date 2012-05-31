class CreateChouetteGroupOfLineLine < ActiveRecord::Migration
  def up
    create_table :groupofline_line, :id => false, :force => true do |t|
      t.integer  "group_of_line_id", :limit => 8
      t.integer  "line_id",        :limit => 8
    end
  end

  def down
    drop_table :groupofline_line
  end
end
