class Chouette::Line < Chouette::ActiveRecord
  belongs_to :company
  belongs_to :network
  has_many :routes, :dependent => :destroy
end
