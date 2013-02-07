require "forwardable"

class AddForeignKeys < ActiveRecord::Migration
  def up
    # t.remove_foreign_key does not works if foreign key doesn't exists (IF EXISTS missing)
    change_table :access_links do |t|
      execute <<-SQL
        ALTER TABLE "access_links" DROP CONSTRAINT IF EXISTS "aclk_acpt_fkey" ;
        ALTER TABLE "access_links" DROP CONSTRAINT IF EXISTS "aclk_area_fkey" ;
      SQL
      t.foreign_key :access_points, :dependent => :delete, :name => 'aclk_acpt_fkey'
      t.foreign_key :stop_areas, :dependent => :delete, :name => 'aclk_area_fkey'
    end
    change_table :access_points do |t|
      execute <<-SQL
        ALTER TABLE "access_points" DROP CONSTRAINT IF EXISTS "access_area_fkey" ;
      SQL
      t.foreign_key :stop_areas, :dependent => :delete, :name => 'access_area_fkey'
    end
    change_table :connection_links do |t|
      execute <<-SQL
        ALTER TABLE "connection_links" DROP CONSTRAINT IF EXISTS "colk_endarea_fkey" ;
        ALTER TABLE "connection_links" DROP CONSTRAINT IF EXISTS "colk_startarea_fkey" ;
      SQL
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'arrival_id', :name => 'colk_endarea_fkey'
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'departure_id', :name => 'colk_startarea_fkey'
    end
    change_table :group_of_lines_lines do |t|
      execute <<-SQL
        ALTER TABLE "group_of_lines_lines" DROP CONSTRAINT IF EXISTS "groupofline_group_fkey" ;
        ALTER TABLE "group_of_lines_lines" DROP CONSTRAINT IF EXISTS "groupofline_line_fkey" ;
      SQL
      t.foreign_key :group_of_lines, :dependent => :delete, :name => 'groupofline_group_fkey'
      t.foreign_key :lines, :dependent => :delete,  :name => 'groupofline_line_fkey'
    end
    change_table :journey_patterns do |t|
      execute <<-SQL
        ALTER TABLE "journey_patterns" DROP CONSTRAINT IF EXISTS "arrival_stop_point_id" ;
        ALTER TABLE "journey_patterns" DROP CONSTRAINT IF EXISTS "departure_stop_point_id" ;
        ALTER TABLE "journey_patterns" DROP CONSTRAINT IF EXISTS "jp_route_fkey" ;
      SQL
      t.foreign_key :stop_points, :dependent => :nullify, :column => 'arrival_stop_point_id', :name => 'arrival_point_fkey'
      t.foreign_key :stop_points, :dependent => :nullify, :column => 'departure_stop_point_id', :name => 'departure_point_fkey'
      t.foreign_key :routes, :dependent => :delete,  :name => 'jp_route_fkey'
    end
    change_table :journey_patterns_stop_points do |t|
      execute <<-SQL
        ALTER TABLE "journey_patterns_stop_points" DROP CONSTRAINT IF EXISTS "jpsp_jp_fkey" ;
        ALTER TABLE "journey_patterns_stop_points" DROP CONSTRAINT IF EXISTS "jpsp_stoppoint_fkey" ;
      SQL
      t.foreign_key :journey_patterns, :dependent => :delete, :name => 'jpsp_jp_fkey'
      t.foreign_key :stop_points, :dependent => :delete,  :name => 'jpsp_stoppoint_fkey'
    end
    change_table :lines do |t|
      execute <<-SQL
        ALTER TABLE "lines" DROP CONSTRAINT IF EXISTS "line_company_fkey" ;
        ALTER TABLE "lines" DROP CONSTRAINT IF EXISTS "line_ptnetwork_fkey" ;
      SQL
      t.foreign_key :companies, :dependent => :nullify, :name => 'line_company_fkey'
      t.foreign_key :networks, :dependent => :nullify,  :name => 'line_ptnetwork_fkey'
    end
    change_table :routes do |t|
      execute <<-SQL
        ALTER TABLE "routes" DROP CONSTRAINT IF EXISTS "route_line_fkey" ;
      SQL
      t.foreign_key :lines, :dependent => :delete, :name => 'route_line_fkey'
    end
    change_table :routing_constraints_lines do |t|
      execute <<-SQL
        ALTER TABLE "routing_constraints_lines" DROP CONSTRAINT IF EXISTS "routingconstraint_line_fkey" ;
        ALTER TABLE "routing_constraints_lines" DROP CONSTRAINT IF EXISTS "routingconstraint_stoparea_fkey" ;
      SQL
      t.foreign_key :lines, :dependent => :delete, :name => 'routingconstraint_line_fkey'
      t.foreign_key :stop_areas, :dependent => :delete,  :name => 'routingconstraint_stoparea_fkey'
    end
    change_table :stop_areas do |t|
      execute <<-SQL
        ALTER TABLE "stop_areas" DROP CONSTRAINT IF EXISTS "area_parent_fkey" ;
      SQL
      t.foreign_key :stop_areas, :dependent => :nullify, :column => 'parent_id', :name => 'area_parent_fkey'
    end
    change_table :stop_areas_stop_areas do |t|
      execute <<-SQL
        ALTER TABLE "stop_areas_stop_areas" DROP CONSTRAINT IF EXISTS "stoparea_child_fkey" ;
        ALTER TABLE "stop_areas_stop_areas" DROP CONSTRAINT IF EXISTS "stoparea_parent_fkey" ;
      SQL
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'child_id', :name => 'stoparea_child_fkey'
      t.foreign_key :stop_areas, :dependent => :delete, :column => 'parent_id', :name => 'stoparea_parent_fkey'
    end
    change_table :stop_points do |t|
      execute <<-SQL
        ALTER TABLE "stop_points" DROP CONSTRAINT IF EXISTS "stoppoint_area_fkey" ;
        ALTER TABLE "stop_points" DROP CONSTRAINT IF EXISTS "stoppoint_route_fkey" ;
      SQL
      t.foreign_key :stop_areas, :name => 'stoppoint_area_fkey'
      t.foreign_key :routes, :dependent => :delete,  :name => 'stoppoint_route_fkey'
    end
    change_table :time_table_dates do |t|
      execute <<-SQL
        ALTER TABLE "time_table_dates" DROP CONSTRAINT IF EXISTS "tm_date_fkey" ;
      SQL
      t.foreign_key :time_tables, :dependent => :delete,  :name => 'tm_date_fkey'
    end
    change_table :time_table_periods do |t|
      execute <<-SQL
        ALTER TABLE "time_table_periods" DROP CONSTRAINT IF EXISTS "tm_period_fkey" ;
      SQL
      t.foreign_key :time_tables, :dependent => :delete,  :name => 'tm_period_fkey'
    end
    change_table :time_tables_vehicle_journeys do |t|
      execute <<-SQL
        ALTER TABLE "time_tables_vehicle_journeys" DROP CONSTRAINT IF EXISTS "vjtm_tm_fkey" ;
        ALTER TABLE "time_tables_vehicle_journeys" DROP CONSTRAINT IF EXISTS "vjtm_vj_fkey" ;
      SQL
      t.foreign_key :time_tables, :dependent => :delete,  :name => 'vjtm_tm_fkey'
      t.foreign_key :vehicle_journeys, :dependent => :delete,  :name => 'vjtm_vj_fkey'
    end
    change_table :vehicle_journey_at_stops do |t|
      execute <<-SQL
        ALTER TABLE "vehicle_journey_at_stops" DROP CONSTRAINT IF EXISTS "vjas_sp_fkey" ;
        ALTER TABLE "vehicle_journey_at_stops" DROP CONSTRAINT IF EXISTS "vjas_vj_fkey" ;
      SQL
      t.foreign_key :stop_points, :dependent => :delete,  :name => 'vjas_sp_fkey'
      t.foreign_key :vehicle_journeys, :dependent => :delete,  :name => 'vjas_vj_fkey'
    end
    change_table :vehicle_journeys do |t|
      execute <<-SQL
        ALTER TABLE "vehicle_journeys" DROP CONSTRAINT IF EXISTS "vj_company_fkey" ;
        ALTER TABLE "vehicle_journeys" DROP CONSTRAINT IF EXISTS "vj_jp_fkey" ;
        ALTER TABLE "vehicle_journeys" DROP CONSTRAINT IF EXISTS "vj_route_fkey" ;
      SQL
      t.foreign_key :companies, :dependent => :nullify,  :name => 'vj_company_fkey'
      t.foreign_key :journey_patterns, :dependent => :delete,  :name => 'vj_jp_fkey'
      t.foreign_key :routes, :dependent => :delete,  :name => 'vj_route_fkey'
    end
    
  end

  def down
    change_table :access_links do |t|
      t.remove_foreign_key :aclk_acpt_fkey
      t.remove_foreign_key :aclk_area_fkey
    end
    change_table :access_points do |t|
      t.remove_foreign_key :access_area_fkey
    end
    change_table :connection_links do |t|
      t.remove_foreign_key :name => :colk_endarea_fkey
      t.remove_foreign_key :name => :colk_startarea_fkey
    end
    change_table :group_of_lines_lines do |t|
      t.remove_foreign_key :name => :groupofline_group_fkey
      t.remove_foreign_key :name => :groupofline_line_fkey
    end
    change_table :journey_patterns do |t|
      t.remove_foreign_key :name => :arrival_point_fkey
      t.remove_foreign_key :name => :departure_point_fkey
      t.remove_foreign_key :name => :jp_route_fkey
    end
    change_table :journey_patterns_stop_points do |t|
      t.remove_foreign_key :name => :jpsp_jp_fkey
      t.remove_foreign_key :name => :jpsp_stoppoint_fkey
    end
    change_table :lines do |t|
      t.remove_foreign_key :name => :line_company_fkey
      t.remove_foreign_key :name => :line_ptnetwork_fkey
    end
    change_table :routes do |t|
      t.remove_foreign_key :name => :route_line_fkey
    end
    change_table :routing_constraints_lines do |t|
      t.remove_foreign_key :name => :routingconstraint_line_fkey
      t.remove_foreign_key :name => :routingconstraint_stoparea_fkey
    end
    change_table :stop_areas do |t|
      t.remove_foreign_key :name => :area_parent_fkey
    end
    change_table :stop_areas_stop_areas do |t|
      t.remove_foreign_key :name => :stoparea_child_fkey
      t.remove_foreign_key :name => :stoparea_parent_fkey
    end
    change_table :stop_points do |t|
      t.remove_foreign_key :name => :stoppoint_area_fkey
      t.remove_foreign_key :name => :stoppoint_route_fkey
    end
    change_table :time_table_dates do |t|
      t.remove_foreign_key :name => :tm_date_fkey
    end
    change_table :time_table_periods do |t|
      t.remove_foreign_key :name => :tm_period_fkey
    end
    change_table :time_tables_vehicle_journeys do |t|
      t.remove_foreign_key :name => :vjtm_tm_fkey
      t.remove_foreign_key :name => :vjtm_vj_fkey
    end
    change_table :vehicle_journey_at_stops do |t|
      t.remove_foreign_key :name => :vjas_sp_fkey
      t.remove_foreign_key :name => :vjas_vj_fkey
    end
    change_table :vehicle_journeys do |t|
      t.remove_foreign_key :name => :vj_company_fkey
      t.remove_foreign_key :name => :vj_jp_fkey
      t.remove_foreign_key :name => :vj_route_fkey
    end
  end
end
