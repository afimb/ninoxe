class AddDistanceToRouteSections < ActiveRecord::Migration

  def change
    add_column "route_sections", "distance", "float"
  end

end
