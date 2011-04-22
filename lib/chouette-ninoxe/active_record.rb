require "yaml"
require "active_record"
require "action_controller"

class Chouette::ActiveRecord < ::ActiveRecord::Base
  self.abstract_class = true

  def self.compute_table_name
    inflector super.singularize.gsub("_","").gsub(/timetable(period|date)/,"timetable_\\1")
  end

  def self.inflector(name)
    name.gsub("time_table","timetable").gsub(/^network/,"ptnetwork")
  end

  def self.create_reflection(macro, name, options, active_record)
    unless options[:foreign_key]
      foreign_key_name = macro == :belongs_to ? name.to_s : active_record.name
      options[:foreign_key] = inflector(foreign_key_name.foreign_key(false))
    end

    unless options[:class_name]
      default_class_name = name.to_s
      default_class_name = default_class_name.singularize if macro == :has_many
      options[:class_name] = "Chouette::#{default_class_name.camelize}"
    end

    super 
  end

  def self.potential_config_files
    [].tap do |paths|
      paths << File.join(Rails.root, "config", "database_chouette.yml") if defined?(Rails)
      paths << File.join(RAILS_ROOT, "config", "database_chouette.yml") if defined?(RAILS_ROOT)
      paths << File.join(File.dirname(__FILE__), "..", "database_chouette.yml")
    end
  end

  def self.config_file
    self.potential_config_files.find { |p| File.exists?(p) }
  end

  def self.configurations
    @@db_config ||= YAML.load(ERB.new(IO.read( self.config_file)).result)
  rescue =>  e
    puts "database_chouette.yml not found in #{self.potential_config_files.inspect} #{e.message} #{e.backtrace.join("\n")}"
    raise Exception.new( "database_chouette.yml not found in #{self.potential_config_files.inspect}")
  end

  def self.configuration
    self.configurations[Chouette.env] rescue nil
  end
  
  def self.init_db_connection
    if self.configuration.nil?
      puts "No configuration for chouette database found, Chouette.env=#{Chouette.env}"
    else
      establish_connection(self.configuration)
    end
  end
  
  def self.connected?
    ! self.connection.nil?
  rescue => e
    false
  end
  
end
