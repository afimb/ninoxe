module DatabaseCleaner

  class << self
    alias_method :orm_module_without_chouette, :orm_module

    def orm_module(symbol)
      if :chouette_active_record
        DatabaseCleaner::ChouetteActiveRecord
      else
        orm_module_without_chouette symbol
      end
    end
  end

  module ChouetteActiveRecord
    module Base
      def connection_klass
        Class.new(Chouette::ActiveRecord)
      end
    end
  end
end
