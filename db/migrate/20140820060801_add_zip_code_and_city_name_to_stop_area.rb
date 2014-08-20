class AddZipCodeAndCityNameToStopArea < ActiveRecord::Migration
  def change
    change_table :stop_areas do |t|
      t.string :zip_code
      t.string :city_name
    end
  end
end
