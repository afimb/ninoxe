class Chouette::StopPoint < Chouette::ActiveRecord
  belongs_to :stop_area
  belongs_to :route
  acts_as_list :scope => 'routeid = \'#{route.id}\''

  has_many :vehicle_journey_at_stops, :dependent => :destroy
  has_many :vehicle_journeys, :through => :vehicle_journey_at_stops, :uniq => true
  
  scope :default_order, order("position")

  OBJECT_ID_KEY='StopPoint'

  validates_presence_of :objectid
  validates_uniqueness_of :objectid
  validates_numericality_of :objectversion

  def self.objectid_format
    Regexp.new "\\A[0-9A-Za-z_]+:#{model_name}:[0-9A-Za-z_-]+\\Z"
  end
  def self.model_name
    ActiveModel::Name.new Chouette::StopPoint, Chouette, "StopPoint"
  end
  validates_format_of :objectid, :with => self.objectid_format

  def objectid
    Chouette::ObjectId.new read_attribute(:objectid)
  end

  def version
    self.objectversion
  end

  def version=(version)
    self.objectversion = version
  end

  before_validation :default_values, :on => :create
  def default_values
    self.version ||= 1
  end

  def timestamp_attributes_for_update #:nodoc:
    [:creationtime]
  end
  
  def timestamp_attributes_for_create #:nodoc:
    [:creationtime]
  end

  def self.area_candidates
    Chouette::StopArea.where( :areatype => ['Quay', 'BoardingPosition'])
  end

end
