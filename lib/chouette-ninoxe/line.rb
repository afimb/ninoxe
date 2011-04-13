class Chouette::Line < Chouette::ActiveRecord
  set_table_name :line
  
  belongs_to :company, :class_name => "Chouette::Company", :foreign_key => "companyid"
  belongs_to :pt_network, :class_name => "Chouette::PTNetwork", :foreign_key => "ptnetworkid"
  has_many :routes, :class_name => "Chouette::Route", :foreign_key => "lineid", :dependent => :destroy
end
