class SetInOutToTimetableDate < ActiveRecord::Migration
  def up
    Chouette::TimeTableDate.update_all( :in_out => true)
  end

  def down
  end
end
