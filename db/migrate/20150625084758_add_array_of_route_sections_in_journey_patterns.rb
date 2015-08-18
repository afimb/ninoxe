class AddArrayOfRouteSectionsInJourneyPatterns < ActiveRecord::Migration

  def change
    change_table :journey_patterns do |t|
      t.integer :route_section_ids, array: true, default: []
      t.index :route_section_ids, using: :gin
    end
  end

end
