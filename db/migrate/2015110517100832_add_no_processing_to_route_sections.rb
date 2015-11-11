class AddNoProcessingToRouteSections < ActiveRecord::Migration

  def change
    add_column :route_sections, :no_processing, :boolean
  end

end
