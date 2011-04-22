class Chouette::Route < Chouette::ActiveRecord
  belongs_to :line
  has_many :stop_points, :order => 'position', :dependent => :destroy
  has_many :stop_areas, :through => :stop_points, :order => 'stoppoint.position' 
  has_many :vehicle_journeys, :dependent => :destroy
end

