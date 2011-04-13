module Chouette #:nodoc:
  class Railtie < Rails::Railtie #:nodoc:
    rake_tasks do
      load Pathname.new(__FILE__) + ".." + ".." + "tasks" + "database.rake"
    end
    initializer "initialize connection to Chouette" do
      config.after_initialize do
        Chouette::ActiveRecord.init_db_connection
      end
    end
  end
end
