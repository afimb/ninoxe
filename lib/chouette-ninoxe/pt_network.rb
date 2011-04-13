class Chouette::PTNetwork < Chouette::ActiveRecord
  set_table_name :ptnetwork
  has_many :lines, :class_name => "Chouette::Line", :foreign_key => "ptnetworkid"
  
end

