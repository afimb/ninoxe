class Chouette::StopArea < Chouette::ActiveRecord
  set_table_name :stoparea

  has_many :stop_points, :class_name => "Chouette::StopPoint", :foreign_key => "stopareaid", :order => 'position', :dependent => :destroy
  #has_many :stop_area_places
  #has_many :places, :through => :stop_area_places
  
  def self.commercial
    where( :areatype => "CommercialStopPoint")
  end

end
