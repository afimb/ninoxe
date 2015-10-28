class AddTimebandIdToJourneyFrequencies < ActiveRecord::Migration
  def change
    add_reference :journey_frequencies, :timeband, index: true
  end
end
