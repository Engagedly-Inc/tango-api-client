# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Resource for Choice Products catalog and details.
      class ChoiceProducts < Base
        # GET /choiceProducts
        # Params may include: rewardName, currencyCode, countries: []
        def get(params = {})
          get_json("choiceProducts", params)
        end

        # GET /choiceProducts/{utid}
        def get_for_utid(utid)
          get_json("choiceProducts/#{utid}")
        end

        # GET /choiceProducts/{choiceProductUtid}/catalog
        # Supports typical catalog query params, including filters and verbosity flags.
        def catalog(choice_product_utid, params = {})
          get_json("choiceProducts/#{choice_product_utid}/catalog", params)
        end
      end
    end
  end
end
