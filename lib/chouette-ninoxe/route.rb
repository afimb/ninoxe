class Chouette::Route < Chouette::ActiveRecord
  set_table_name :route
  
  belongs_to :line, :class_name => "Chouette::Line", :foreign_key => "lineid"
  has_many :stop_points, :class_name => "Chouette::StopPoint", :foreign_key => "routeid", :order => 'position'
  has_many :stop_areas, :through => :stop_points, :order => 'stoppoint.position' 
  has_many :vehicle_journeys, :class_name => "VehicleJourney", :foreign_key => "routeid", :dependent => :destroy
end

