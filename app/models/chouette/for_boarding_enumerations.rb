module Chouette
  module ForBoardingEnumerations
    extend Enumerize
    extend ActiveModel::Naming

    enumerize :for_boarding, in: %w[undefined normal forbidden request_stop is_flexible], default: "undefined"
  end
end
