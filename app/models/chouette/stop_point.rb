class Chouette::StopPoint < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :stop_area
  belongs_to :route
  acts_as_list :scope => 'routeid = \'#{route.id}\''

  has_many :vehicle_journey_at_stops, :dependent => :destroy
  has_many :vehicle_journeys, :through => :vehicle_journey_at_stops, :uniq => true
  
  scope :default_order, order("position")

  def self.area_candidates
    Chouette::StopArea.where( :areatype => ['Quay', 'BoardingPosition'])
  end

end
