class Chouette::Line < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  attr_accessor :transport_mode
  attr_accessible :transport_mode, :network_id, :company_id, :objectid, :object_version
  attr_accessible :creation_time, :creator_id, :name, :number, :published_name, :transport_mode_name
  attr_accessible :registration_number, :comment, :mobility_restricted_suitability, :int_user_needs
  attr_accessible :flexible_service

  belongs_to :company
  belongs_to :network
  has_many :routes, :dependent => :destroy
  has_many :journey_patterns, :through => :routes
  has_many :vehicle_journeys, :through => :journey_patterns

  has_and_belongs_to_many :group_of_lines, :class_name => 'Chouette::GroupOfLine', :order => 'group_of_lines.name'

  has_many :footnotes, :dependent => :destroy
  accepts_nested_attributes_for :footnotes, :reject_if => :all_blank, :allow_destroy => true
  attr_accessible :footnotes_attributes

  attr_accessible :group_of_lines, :group_of_line_ids, :group_of_line_tokens
  attr_accessible :url, :color, :text_color
  attr_reader :group_of_line_tokens

  validates_presence_of :network
  validates_presence_of :company

  validates_presence_of :registration_number
  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[\d\w_\-]+\Z}
  validates_format_of :url, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :color, :with => %r{\A[0-9a-fA-F]{6}\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :text_color, :with => %r{\A[0-9a-fA-F]{6}\Z}, :allow_nil => true, :allow_blank => true

  validates_presence_of :name

  def self.nullable_attributes
    [:published_name, :number, :comment, :url, :color, :text_color]
  end

  def geometry_presenter
    Chouette::Geometry::LinePresenter.new self
  end

  def transport_mode
    # return nil if transport_mode_name is nil
    transport_mode_name && Chouette::TransportMode.new( transport_mode_name.underscore)
  end

  def transport_mode=(transport_mode)
    self.transport_mode_name = (transport_mode ? transport_mode.camelcase : nil)
  end

  @@transport_modes = nil
  def self.transport_modes
    @@transport_modes ||= Chouette::TransportMode.all.select do |transport_mode|
      transport_mode.to_i > 0
    end
  end

  def commercial_stop_areas
    Chouette::StopArea.joins(:children => [:stop_points => [:route => :line] ]).where(:lines => {:id => self.id}).uniq
  end

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => :line]).where(:lines => {:id => self.id})
  end

  def stop_areas_last_parents
    Chouette::StopArea.joins(:stop_points => [:route => :line]).where(:lines => {:id => self.id}).collect(&:root).flatten.uniq
  end

  def group_of_line_tokens=(ids)
    self.group_of_line_ids = ids.split(",")
  end


end
