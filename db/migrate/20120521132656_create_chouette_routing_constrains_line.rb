class CreateChouetteRoutingConstrainsLine < ActiveRecord::Migration
  def up
    create_table :routingconstraints_lines, :id => false, :force => true do |t|
      t.integer  "stopareaid", :limit => 8
      t.integer  "lineid",     :limit => 8
    end
  end

  def down
    drop_table :routingconstraints_lines
  end
end
