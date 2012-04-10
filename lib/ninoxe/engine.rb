module Ninoxe
  class Engine < ::Rails::Engine
   
    config.generators do |g|                                                               
      g.test_framework :rspec
      g.integration_tool :rspec
    end
        
    initializer "ninoxe", :after => :eager_load! do
      puts Rails.configuration.database_configuration["chouette"].inspect
      ::Chouette::ActiveRecord.establish_connection Rails.configuration.database_configuration["chouette"] if Rails.configuration.database_configuration["chouette"].present?

      ::Chouette::ActiveRecord.logger = Rails.logger
    end
  end
end
