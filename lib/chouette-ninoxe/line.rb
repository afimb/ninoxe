class Chouette::Line < Chouette::ActiveRecord
  belongs_to :company
  belongs_to :network
  has_many :routes, :dependent => :destroy

  def objectid
    Chouette::ObjectId.new read_attribute(:objectid)
  end
end
