#require "active_record"

module Chouette
  class ActiveRecord < ::ActiveRecord::Base

    self.abstract_class = true

    def human_attribute_name(*args)
      self.class.human_attribute_name(*args)
    end

    def self.compute_table_name
      Inflector.chouettify super.singularize
    end

    def method_missing(method, *args, &block)
      # Rails.logger.error("method_missing : #{method}")
      # puts "method_missing : #{method}"
      method_without_underscore = method.to_s.gsub(/(\w)_/, "\\1")
      if method_without_underscore == method.to_s
        # to avoid endless loop
        super
      else
        if respond_to?(method_without_underscore)
          send(method_without_underscore, *args, &block)
        else
          super
        end
      end
    end

    def respond_to?(method, include_private = false)
      # Rails.logger.error("respond_to? : #{method}")
      # puts "respond_to : #{method}"
      method_without_underscore = method.to_s.gsub(/(\w)_/, "\\1")
      if method_without_underscore == method.to_s 
        super
      else
        super || super(method_without_underscore, include_private)
      end
    end

    class << self
      alias_method :create_reflection_without_chouette_naming, :create_reflection

      def create_reflection(macro, name, options, active_record)
        options = 
          Reflection.new(macro, name, options, active_record).options_with_default

        create_reflection_without_chouette_naming(macro, name, options, active_record)
      end
    end


    module Inflector

      @@rewrites = 
        [["_", ""],
         [ "time_table", "timetable" ],
         [ "journey_pattern", "journeypattern" ],
         [ "journey_pattern_stop_point", "journeypattern_stoppoint" ],
         [ /timetable(period|date)/, "timetable_\\1" ],
         [ /^network/, "ptnetwork" ]
        ]
      
      def chouettify(name)
        @@rewrites.inject(name) do |name, rewrite|
          pattern, replace = rewrite
          name.gsub pattern, replace
        end
      end

      module_function :chouettify

    end

    class Reflection
      include Inflector

      attr_reader :macro, :name, :options, :active_record

      def initialize(macro, name, options, active_record)
        @macro, @name, @options, @active_record = macro, name.to_s, options, active_record
      end

      def collection?
        macro == :has_many
      end

      def singular_name
        collection? ? name.singularize : name
      end

      def class_name
        "Chouette::#{singular_name.camelize}"
      end

      def foreign_key_name
        collection? ? active_record.name : name
      end

      def foreign_key
        foreign_key_name.foreign_key(true)
      end

      def options_with_default
        options.dup.tap do |options|
          options[:foreign_key] ||= foreign_key
          options[:class_name] ||= class_name
        end
      end

    end

  end
end
