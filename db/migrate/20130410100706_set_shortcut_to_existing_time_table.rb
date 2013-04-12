class SetShortcutToExistingTimeTable < ActiveRecord::Migration
  def up
    Chouette::TimeTable.all.each do |t|
      t.shortcuts_update
    end
  end

  def down
  end
end
