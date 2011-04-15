# -*- coding: utf-8 -*-
namespace :db do
  namespace "chouette-ninoxe".to_sym do
    root_path = File.dirname(File.dirname(File.dirname(__FILE__)))
    
    task :load_model do
      require File.join(root_path,"lib","chouette-ninoxe")
    end
    
    task :environment => [:load_rails, :load_model] do
      Chouette::ActiveRecord.init_db_connection
#      if Chouette.enabled?
#        Chouette::ActiveRecord.logger ||= Logger.new('log/database.log')
#      end
    end

    task :load_rails do
      begin
        rails_environment = Rake::Task["environment"] 
      rescue RuntimeError => e
        # task doesn't exist 
      end
      
      rails_environment.invoke if rails_environment
    end

    desc 'Load database schema for test purpose'
    task :dataless_restore => :environment do
      result = Chouette::Loader.load( Pathname.new(__FILE__)+".."+".."+".."+"db"+"empty_database.sql")
      puts ( result ? "sucess" : "failure")
    end

    desc 'Create the database from config/database.yml for the current Rails.env (use db:create:all to create all dbs in the config)'
    task :create => :environment do
      # Make the test database at the same time as the development one, if it exists
      if Chouette.env=="development" && Chouette::ActiveRecord.configurations['test']
        create_database(Chouette::ActiveRecord.configurations['test'])
      end
      create_database(Chouette::ActiveRecord.configurations[Chouette.env])
    end

    # See gems/activerecord-.../lib/active_record/railties/databases.rake
    def create_database(config)
      begin
        if config['adapter'] =~ /sqlite/
          if File.exist?(config['database'])
            $stderr.puts "#{config['database']} already exists sqllite"
          else
            begin
              # Create the SQLite database
              ActiveRecord::Base.establish_connection(config)
              ActiveRecord::Base.connection
            rescue Exception => e
              $stderr.puts e, *(e.backtrace)
              $stderr.puts "Couldn't create database for #{config.inspect}"
            end
          end
          return # Skip the else clause of begin/rescue
        else
          ActiveRecord::Base.establish_connection(config)
          ActiveRecord::Base.connection
        end
      rescue
        case config['adapter']
        when 'postgresql'
          encoding = config['encoding'] || ENV['CHARSET'] || 'utf8'
          begin
            ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
            ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => encoding))
            ActiveRecord::Base.establish_connection(config)
          rescue Exception => e
            $stderr.puts e, *(e.backtrace)
            $stderr.puts "Couldn't create database for #{config.inspect}"
          end
        end
      else
        $stderr.puts "#{config['database']} already exists fin"
      end
    end

    desc "Migrate the 'chouette_database' through gem's scripts in db/migrate. Target specific version with VERSION=x"
    task :migrate => :environment do
      if Chouette.enabled?
        begin
          config = Chouette::ActiveRecord.configuration
          dir = Pathname.new(__FILE__) + ".." + ".." + ".." + "db"
          file = if config['adapter'] =~ /sqlite/
            "empty_database_sqlite.sql"
          elsif config['adapter'] = "postgresql"
            "empty_database.sql"
          else
            raise "No dump for such a database adapter #{config['adapter']}"
          end

          if config['adapter'] =~ /sqlite/
            system("#{config['adapter']} #{config['database']} < #{dir+file}")
          elsif config['adapter'] = "postgresql"
            ENV['PGHOST']     = config["host"] if config["host"]
            ENV['PGPORT']     = config["port"].to_s if config["port"]
            ENV['PGPASSWORD'] = config["password"].to_s if config["password"]
            system("psql -U #{config['username']} -f #{dir+file} #{config['database']}")
          end

          puts "success !!!"
        rescue => e
          puts "Echec #{e.inspect}"
          puts e.backtrace.join("\n")
        end
      end
    end

  end
  
end
