class Chouette::StopArea < Chouette::ActiveRecord
  has_many :stop_points, :dependent => :destroy
end
