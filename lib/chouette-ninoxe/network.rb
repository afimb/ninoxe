class Chouette::Network < Chouette::ActiveRecord
  
  OBJECT_ID_KEY='GroupOfLine'
  
  include Chouette::ActiveRecord::ObjectIdManagement
  
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key "id"

  has_many :lines

  validates_presence_of :registration_number
  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  validates_presence_of :name

  validates_presence_of :objectid
  validates_uniqueness_of :objectid
  validates_format_of :objectid, :with => %r{\A[0-9A-Za-z_]+:GroupOfLine:[0-9A-Za-z_-]+\Z}


  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:lines => :network] ]).where(:ptnetwork => {:id => self.id})
  end
  
end

