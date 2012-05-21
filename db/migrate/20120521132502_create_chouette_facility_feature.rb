class CreateChouetteFacilityFeature < ActiveRecord::Migration
  def up
    create_table :facilityfeature, :id => false, :force => true do |t|
      t.integer  "facilityid", :limit => 8
      t.integer  "choicecode"
    end
  end

  def down
    drop_table :facilityfeature 
  end
end
