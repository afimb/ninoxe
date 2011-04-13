class Chouette::Loader
  def initialize( schema, backup_path)
    @schema = schema
    @backup_path = backup_path
  end

  def backup_path
    @backup_path
  end

  def schema
    @schema
  end

  def self.load(path)
    # TODO: Hoptoad en cas d'échec
    system("psql -f #{path} #{Chouette::ActiveRecord.configuration["database"]}")
  end

  # Load dump where datas are in schema 'chouette'
  def load_chouette_dump(path)
    self.drop_chouette 
    # TODO: Hoptoad en cas d'échec
    system("cat #{path} | sed -e 's/ chouette/ #{self.schema}/' | psql #{Chouette::ActiveRecord.configuration["database"]}")
  end

  def backup_chouette
    return unless self.backup_path

    pathname = Pathname.new( self.backup_path.to_s)
    pathname.dirname.mkpath unless pathname.dirname.exist? 
    pathname.delete if pathname.exist?
    # TODO: Hoptoad en cas d'échec
    system("pg_dump -n #{self.schema} #{Chouette::ActiveRecord.configuration["database"]} > #{pathname}")
  end

  def drop_chouette
    self.backup_chouette
    # TODO: Hoptoad en cas d'échec
    system("psql -c 'DROP SCHEMA #{self.schema} CASCADE;' #{Chouette::ActiveRecord.configuration["database"]}")
  end
end
