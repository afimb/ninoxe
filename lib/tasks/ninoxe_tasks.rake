# desc "Explaining what the task does"
# task :ninoxe do
#   # Task goes here
# end
# -*- coding: utf-8 -*-
# require 'erb'

# namespace :db do
#   namespace "ninoxe".to_sym do
#     root_path = File.dirname(File.dirname(File.dirname(__FILE__)))
    
#     task :load_model do
#       require File.join(root_path,"lib","ninoxe")
#     end

#     task :load_rails do
#       begin
#         rails_environment = Rake::Task["environment"] 
#       rescue RuntimeError => e
#         # task doesn't exist 
#       end
      
#       rails_environment.invoke if rails_environment
#     end

#     def configuration
#       if defined?( Rails)
#         Rails.configuration.database_configuration[ "chouette"]
#       else
#         YAML::load( ERB.new( IO.read( File.expand_path('../../../config/database.yml', __FILE__))).result)["default"]
#       end.stringify_keys
#     end

#     # See gems/activerecord-.../lib/active_record/railties/databases.rake
#     desc 'Create the database from config/database.yml for the current Rails.env (use db:create:all to create all dbs in the config)'
#     task :create => [:load_rails, :load_model] do
#       config = configuration
#       begin
#         if config['adapter'] =~ /sqlite/
#           if File.exist?(config['database'])
#             $stderr.puts "#{config['database']} already exists sqllite"
#           else
#             begin
#               # Create the SQLite database
#               ActiveRecord::Base.establish_connection(config)
#               ActiveRecord::Base.connection
#             rescue Exception => e
#               $stderr.puts e, *(e.backtrace)
#               $stderr.puts "Couldn't create database for #{config.inspect}"
#             end
#           end
#           return # Skip the else clause of begin/rescue
#         else
#           ActiveRecord::Base.establish_connection(config)
#           ActiveRecord::Base.connection
#         end
#       rescue
#         case config['adapter']
#         when 'postgresql'
#           encoding = config['encoding'] || ENV['CHARSET'] || 'utf8'
#           begin
#             ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
#             ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => encoding))
#             ActiveRecord::Base.establish_connection(config)
#           rescue Exception => e
#             $stderr.puts e, *(e.backtrace)
#             $stderr.puts "Couldn't create database for #{config.inspect}"
#           end
#         end
#       else
#         $stderr.puts "#{config['database']} already exists fin"
#       end
#     end

#     desc "Restore an empty 'chouette_database' through an sql backup."
#     task :restore_empty => [:load_rails, :load_model] do
#       begin
#         config = configuration
#         dir = Pathname.new(__FILE__) + ".." + ".." + ".." + "db"
#         file = if config['adapter'] =~ /sqlite/
#           "schema_sqlite.sql"
#         elsif config['adapter'] = "postgresql"
#           "schema.sql"
#         else
#           raise "No dump for such a database adapter #{config['adapter']}"
#         end

#         if config['adapter'] =~ /sqlite/
#           system("#{config['adapter']} #{config['database']} < #{dir+file}")
#         elsif config['adapter'] = "postgresql"
#           ENV['PGHOST']     = config["host"] if config["host"]
#           ENV['PGPORT']     = config["port"].to_s if config["port"]
#           ENV['PGPASSWORD'] = config["password"].to_s if config["password"]
#           user_option = "-U #{config['username']}" if config['username']
#           system("psql #{user_option} -f #{dir+file} #{config['database']}")
#         end

#         puts "success !!!"
#       rescue => e
#         puts "Echec #{e.inspect}"
#         puts e.backtrace.join("\n")
#       end
#     end

#   end
  
# end
