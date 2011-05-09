class Chouette::StopArea < Chouette::ActiveRecord
  has_many :stop_points, :dependent => :destroy
  
  def self.commercial
    where :areatype => "CommercialStopPoint"
  end
end
