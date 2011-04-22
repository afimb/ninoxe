require "active_record"

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
end
