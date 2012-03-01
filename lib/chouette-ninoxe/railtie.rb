module Chouette #:nodoc:
  class Railtie < Rails::Railtie #:nodoc:
    rake_tasks do
      load Pathname.new(__FILE__) + ".." + ".." + "tasks" + "database.rake"
    end
    initializer "initialize connection to Chouette" do
      config.after_initialize do        
        Chouette::ActiveRecord.establish_connection Rails.configuration.database_configuration[ "chouette"] if Chouette::ActiveRecord.establish_chouette_connection

        Chouette::ActiveRecord.logger = Rails.logger
        # get connection effective
        # raise PGError if connection fails
        # 
        # When test db doesn't exists, exception should not be risen
        # Rails.logger.debug("Chouette db counts #{Chouette::Line.count} lines")
      end
    end
  end
end
