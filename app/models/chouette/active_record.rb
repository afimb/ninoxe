#require "active_record"

module Chouette
  class ActiveRecord < ::ActiveRecord::Base

    before_validation :prepare_auto_columns
    after_create :build_objectid

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
      if respond_to?(method_without_underscore)
        send(method_without_underscore, *args, &block)
      else
        super
      end
    end

    def respond_to?(method, include_private = false)
      # Rails.logger.error("respond_to? : #{method}")
      # puts "respond_to : #{method}"
      method_without_underscore = method.to_s.gsub(/(\w)_/, "\\1")
      super || super(method_without_underscore, include_private)
    end

    class << self
      alias_method :create_reflection_without_chouette_naming, :create_reflection

      def create_reflection(macro, name, options, active_record)
        options = 
          Reflection.new(macro, name, options, active_record).options_with_default

        create_reflection_without_chouette_naming(macro, name, options, active_record)
      end
    end

    # triggers to generate objectId and objectVersion 
    # TODO setting prefix in referential object
    
    def prepare_auto_columns
      # logger.info 'calling before_validation'
      if defined? self.objectid && defined? self.class::OBJECT_ID_KEY
        # logger.info 'start before_validation : '+self.objectid.to_s
        if self.objectid.to_s.empty?
          self.objectid = 'NINOXE:'+self.class::OBJECT_ID_KEY+':__pending_id__'+rand(1000).to_s;
        elsif not self.objectid.include? ':'
          self.objectid += ':'+self.class::OBJECT_ID_KEY+':__pending_id__'+rand(1000).to_s;
        end
        # logger.info 'end before_validation : '+self.objectid
      end
      if defined? self.objectversion
        # initialize or update version
        if self.objectversion.nil?
          self.objectversion = 1
        else
          self.object_version += 1
        end
      end
      if defined? self.creationtime
        self.creationtime = Time.now
      end
      if defined? self.creatorid
        self.creatorid = 'chouette'
      end
    end
    
    def build_objectid
      if defined? self.objectid
        # logger.info 'start after_create : '+self.objectid
        if self.objectid.include? ':__pending_id__'
          tokens = self.objectid.rpartition(":")
          self.objectid = tokens[0]+":"+self.id.to_s
          self.object_version += 1
          self.save
        end
        # logger.info 'end after_create : '+self.objectid
      end
    end

    module Inflector

      @@rewrites = 
        [[ /_/, "" ], 
         [ "time_table", "timetable" ],
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
        chouettify foreign_key_name.foreign_key(false)
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
