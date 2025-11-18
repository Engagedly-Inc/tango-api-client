# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Resource for Brand Categories endpoints.
      class BrandCategories < Base
        # GET /brandCategories
        def get
          get_json("brandCategories")
        end
      end
    end
  end
end
