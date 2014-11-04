class AddGtfsFieldsToCompanies < ActiveRecord::Migration
  def change
    change_table :companies do |t|
      t.string :url
      t.string :time_zone
    end
  end
end
