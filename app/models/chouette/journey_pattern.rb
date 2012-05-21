class Chouette::JourneyPattern < Chouette::TridentActiveRecord
  set_table_name "journeypattern"

  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  belongs_to :route
  has_many :vehicle_journeys, :dependent => :destroy
  has_and_belongs_to_many :stop_points, :class_name => 'Chouette::StopPoint', :foreign_key => "journeypatternid", :association_foreign_key => "stoppointid", :join_table => "journeypattern_stoppoint", :order => 'stoppoint.position'

end

