class Chouette::Line < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  attr_accessor :transport_mode

  belongs_to :company
  belongs_to :network
  has_many :routes, :dependent => :destroy

  validates_presence_of :network
  validates_presence_of :company

  validates_presence_of :registrationnumber
  validates_uniqueness_of :registrationnumber
  validates_format_of :registrationnumber, :with => %r{\A[0-9A-Za-z_-]+\Z}

  def valid?(*args)
    super.tap do |valid|
      errors[:registration_number] = errors[:registrationnumber]
    end
  end

  validates_presence_of :name

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

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => :line]).where(:line => {:id => self.id})
  end

  def stop_areas_last_parents
    Chouette::StopArea.joins(:stop_points => [:route => :line]).where(:line => {:id => self.id}).collect(&:root).flatten.uniq
  end

end
