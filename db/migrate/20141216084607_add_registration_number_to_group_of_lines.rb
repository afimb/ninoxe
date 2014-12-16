class AddRegistrationNumberToGroupOfLines < ActiveRecord::Migration
  def change
    add_column :group_of_lines, :registration_number, :string
  end
end
