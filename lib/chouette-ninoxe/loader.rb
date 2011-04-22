class Chouette::Loader
  def initialize( schema, backup_path)
    @schema = schema
    @backup_path = backup_path

    Chouette::ActiveRecord.connection_pool.spec.config.tap do |config|
      @database = config[:database]
      @user = config[:username]
      @password = config[:password]
    end
  end

  def backup_path
    @backup_path
  end

  def schema
    @schema
  end

  def database
    @database
  end

  def user
    @user
  end

  def password
    @password
  end

  # Load dump where datas are in schema 'chouette'
  def load_chouette_dump(path)
    self.drop_chouette 
    # TODO: Hoptoad en cas d'échec
    ENV['PGPASSWORD'] = self.password.to_s if self.password
    system("cat #{path} | sed -e 's/ chouette/ #{self.schema}/' | sed -e 's/ agilis/ #{self.user}/' | psql -U #{self.user} #{ self.database}")
  end

  def backup_chouette
    return unless self.backup_path

    pathname = Pathname.new( self.backup_path.to_s)
    pathname.dirname.mkpath unless pathname.dirname.exist? 
    pathname.delete if pathname.exist?
    # TODO: Hoptoad en cas d'échec
    ENV['PGPASSWORD'] = self.password.to_s if self.password
    system("pg_dump -U #{self.user} -n #{self.schema} #{self.database} > #{pathname}")
  end

  def drop_chouette
    self.backup_chouette
    # TODO: Hoptoad en cas d'échec
    ENV['PGPASSWORD'] = self.password.to_s if self.password
    system( "psql -U #{self.user} -c 'DROP SCHEMA #{self.schema} CASCADE;' #{self.database}")
  end
end
