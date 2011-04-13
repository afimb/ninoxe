class Chouette::Company < Chouette::ActiveRecord
  set_table_name :company

  has_many :lines, :class_name => "Chouette::Line", :foreign_key => "companyid"
end

