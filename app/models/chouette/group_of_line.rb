class Chouette::GroupOfLine < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id
  
  has_and_belongs_to_many :lines, :class_name => 'Chouette::Line', :order => 'lines.name'

  validates_presence_of :name

  attr_accessible :objectid, :object_version, :creation_time, :creator_id, :name, :comment, :lines  
  attr_accessible :line_tokens
  attr_reader :line_tokens
  
  def self.nullable_attributes
    [:comment]
  end
  
  def commercial_stop_areas
    Chouette::StopArea.joins(:children => [:stop_points => [:route => [:line => :group_of_lines] ] ]).where(:group_of_lines => {:id => self.id}).uniq
  end

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:line => :group_of_lines] ]).where(:group_of_lines => {:id => self.id})
  end
  
  def line_tokens=(ids)
    self.line_ids = ids.split(",")
  end

end

