unless defined? Rails
  require "rubygems"
  require "active_record"
end

require File.expand_path('../chouette-ninoxe/active_record', __FILE__)
require File.expand_path('../chouette-ninoxe/loader', __FILE__)
require File.expand_path('../chouette-ninoxe/line', __FILE__)
require File.expand_path('../chouette-ninoxe/company', __FILE__)
require File.expand_path('../chouette-ninoxe/pt_network', __FILE__)
require File.expand_path('../chouette-ninoxe/route', __FILE__)
require File.expand_path('../chouette-ninoxe/journey_pattern', __FILE__)
require File.expand_path('../chouette-ninoxe/stop_area', __FILE__)
require File.expand_path('../chouette-ninoxe/stop_point', __FILE__)
require File.expand_path('../chouette-ninoxe/time_table', __FILE__)
require File.expand_path('../chouette-ninoxe/time_table_date', __FILE__)
require File.expand_path('../chouette-ninoxe/time_table_period', __FILE__)
require File.expand_path('../chouette-ninoxe/time_table_vehicle_journey', __FILE__)
require File.expand_path('../chouette-ninoxe/vehicle_journey_at_stop', __FILE__)
require File.expand_path('../chouette-ninoxe/vehicle_journey', __FILE__)
require File.expand_path('../chouette-ninoxe/railtie', __FILE__) if defined?(Rails)

