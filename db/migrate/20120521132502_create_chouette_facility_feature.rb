class CreateChouetteFacilityFeature < ActiveRecord::Migration
  def up
    create_table :facilityfeature, :id => false, :force => true do |t|
      t.integer  "facility_id", :limit => 8
      t.integer  "choice_code"
    end
  end

  def down
    drop_table :facilityfeature 
  end
end
