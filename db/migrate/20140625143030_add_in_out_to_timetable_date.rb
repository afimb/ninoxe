class AddInOutToTimetableDate < ActiveRecord::Migration
  def change
    add_column "time_table_dates", "in_out", "boolean"
  end
end
