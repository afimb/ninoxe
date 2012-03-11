class Chouette::Company < Chouette::ActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  set_primary_key :id

  has_many :lines
end

