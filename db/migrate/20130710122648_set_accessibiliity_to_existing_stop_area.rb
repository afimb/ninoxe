class SetAccessibiliityToExistingStopArea < ActiveRecord::Migration
  def up
    Chouette::StopArea.update_all( :mobility_restricted_suitability => false,
                                   :stairs_availability => false,
                                   :lift_availability => false,
                                   :int_user_needs => 0)
  end

  def down
  end
end
