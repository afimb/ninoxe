class Chouette::Company < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  has_many :lines
  validates_presence_of :registration_number
  validates_uniqueness_of :registration_number
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}

  validates_presence_of :name

  validates_presence_of :objectid
  validates_uniqueness_of :objectid
  validates_format_of :objectid, :with => %r{\A[0-9A-Za-z_]+:Company:[0-9A-Za-z_-]+\Z}

end

