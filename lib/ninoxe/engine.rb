module Ninoxe
  class Engine < ::Rails::Engine
   
    config.generators do |g|                                                               
      g.test_framework :rspec
      g.integration_tool :rspec
    end
        
    initializer "ninoxe", :after => :eager_load! do
      ::Chouette::ActiveRecord.establish_connection Rails.configuration.database_configuration["chouette"] if Rails.configuration.database_configuration["chouette"].present?

      ::Chouette::ActiveRecord.logger = Rails.logger
    end

    initializer "ninoxe.factories", :after => "factory_girl.set_factory_paths" do
      FactoryGirl.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__) if defined?(FactoryGirl)
    end
  end
end
