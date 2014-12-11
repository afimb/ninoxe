module Chouette
  module ForAlightingEnumerations
    extend Enumerize
    extend ActiveModel::Naming
    
    enumerize :for_alighting, in: %w[undefined normal forbidden request_stop is_flexible], default: "undefined"
  end
end
