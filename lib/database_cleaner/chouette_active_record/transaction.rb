require 'database_cleaner/chouette_active_record/base'
require 'database_cleaner/active_record/transaction'

module DatabaseCleaner
  module ChouetteActiveRecord
    class Transaction < DatabaseCleaner::ActiveRecord::Transaction
      include DatabaseCleaner::ChouetteActiveRecord::Base
    end
  end
end
