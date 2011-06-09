class Chouette::StopArea < Chouette::ActiveRecord
  has_many :stop_points, :dependent => :destroy
  
  def self.commercial
    where :areatype => "CommercialStopPoint"
  end

  def to_lat_lng
    Geokit::LatLng.new latitude, longitude
  end

end
