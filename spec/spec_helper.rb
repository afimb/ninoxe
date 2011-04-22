require 'rspec'

require File.expand_path('../../lib/chouette-ninoxe', __FILE__)

require 'erb'
require 'database_cleaner'

# Patch DatabaseCleaner
# to target the right connection
module DatabaseCleaner
  module ActiveRecord
    module BaseFix
      def self.included( base )
        base.send :include, InstanceMethods
        base.class_eval do
          alias_method :connection_klass, :connection_klass_fix
        end
      end
        
      module InstanceMethods
        def create_connection_klass
          Chouette::ActiveRecord
        end
        def connection_klass_fix
          load_config if connection_hash.nil?

          return ::ActiveRecord::Base if connection_hash.nil?
          klass = create_connection_klass
          klass.send( :establish_connection, connection_hash) unless klass.send( :connected?)
          klass
        end
      end
    end
    class Transaction
      include BaseFix
    end
    class Truncation
      include BaseFix
    end
  end
end

RSpec.configure do |config|

  config.before(:all) do
    Chouette::ActiveRecord.establish_connection( YAML::load( ERB.new( IO.read( File.expand_path('../../config/database.yml', __FILE__))).result)["default"] )
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end


