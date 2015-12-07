class AddSectionStatusToJourneyPattern < ActiveRecord::Migration
  def change
    add_column :journey_patterns, :section_status, :integer, null: false, default: 0
  end
end
