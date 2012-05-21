class CreateChouetteGroupOfLineLine < ActiveRecord::Migration
  def up
    create_table :groupofline_line, :id => false, :force => true do |t|
      t.integer  "groupoflineid", :limit => 8
      t.integer  "lineid",        :limit => 8
    end
  end

  def down
    drop_table :groupofline_line
  end
end
