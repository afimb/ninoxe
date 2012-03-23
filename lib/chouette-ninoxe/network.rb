class Chouette::Network < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  has_many :lines

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:lines => :network] ]).where(:ptnetwork => {:id => self.id})
  end
end

