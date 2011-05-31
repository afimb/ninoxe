require 'database_cleaner/chouette_active_record/base'
require 'database_cleaner/active_record/truncation'

module DatabaseCleaner
  module ChouetteActiveRecord
    class Truncation < DatabaseCleaner::ActiveRecord::Truncation
      include DatabaseCleaner::ChouetteActiveRecord::Base
    end
  end
end
