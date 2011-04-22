module Chouette #:nodoc:
  class Railtie < Rails::Railtie #:nodoc:
    rake_tasks do
      load Pathname.new(__FILE__) + ".." + ".." + "tasks" + "database.rake"
    end
    initializer "initialize connection to Chouette" do
      config.after_initialize do
        Chouette::ActiveRecord.establish_connection Rails.configuration.database_configuration[ "chouette"]
      end
    end
  end
end
