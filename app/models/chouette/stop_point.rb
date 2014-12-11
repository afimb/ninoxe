module Chouette
  class StopPoint < TridentActiveRecord
    include ForBoardingEnumerations
    include ForAlightingEnumerations
    
    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :stop_area
    belongs_to :route, inverse_of: :stop_points
    has_many :vehicle_journey_at_stops, :dependent => :destroy
    has_many :vehicle_journeys, :through => :vehicle_journey_at_stops, :uniq => true
    
    acts_as_list :scope => 'route_id = \'#{route.id}\'',:top_of_list => 0

    attr_accessible :route_id, :stop_area_id, :objectid, :object_version, :creation_time, :creator_id, :position, :for_boarding, :for_alighting

    validates_presence_of :stop_area
    validate :stop_area_id_validation

    scope :default_order, order("position")
    
    before_destroy :remove_dependent_journey_pattern_stop_points
    def remove_dependent_journey_pattern_stop_points
      route.journey_patterns.each do |jp|
        if jp.stop_point_ids.include?( id)
          jp.stop_point_ids = jp.stop_point_ids - [id]
        end
      end
    end  

    def stop_area_id_validation
      if stop_area_id.nil?
        errors.add(:stop_area_id, I18n.t("errors.messages.empty"))
      end
    end

    def self.area_candidates
      Chouette::StopArea.where( :area_type => ['Quay', 'BoardingPosition'])
    end

  end
end
