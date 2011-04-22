unless defined? Rails
  require "rubygems"

  require "yaml"
  require "active_record"
  require "action_controller"

  unless defined? RAILS_ENV
    RAILS_ENV = (ENV["RAILS_ENV"] or "development") 
  end

end

module Chouette
  def self.env
    return Rails.env if defined?(Rails)
    return RAILS_ENV if defined?(RAILS_ENV)
    return ENV['RAILS_ENV'] if ENV['RAILS_ENV']
    return ENV['CHOUETTE_ENV'] if ENV['CHOUETTE_ENV']

    "development"
  end
end

require 'composite_primary_keys'

require 'pathname'
Pathname.new("chouette-ninoxe").tap do |gem_root|
  require gem_root + "active_record"
  require gem_root + "loader"
  require gem_root + "line"
  require gem_root + "company"
  require gem_root + "network"
  require gem_root + "route"
  require gem_root + "journey_pattern"
  require gem_root + "stop_area"
  require gem_root + "stop_point"
  require gem_root + "time_table"
  require gem_root + "time_table_date"
  require gem_root + "time_table_period"
  require gem_root + "time_table_vehicle_journey"
  require gem_root + "vehicle_journey_at_stop"
  require gem_root + "vehicle_journey"
  require ( gem_root + "railtie") if defined?(Rails)
end

module Chouette
  def self.enabled?
    @enabled ||= Chouette::ActiveRecord.connected?
  end
end
