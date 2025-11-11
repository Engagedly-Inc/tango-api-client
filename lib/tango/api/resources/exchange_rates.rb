# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Resource for exchange rates across catalog items and currencies.
      class ExchangeRates < Base
        # GET /exchangeRates
        # Example params: { currency: 'USD', country: 'US' }
        def get(params = {})
          get_json("exchangeRates", params)
        end

        # GET /exchangeRates/{utid}
        # Fetch exchange rate info for a specific catalog item by UTID.
        def get_for_utid(utid, params = {})
          get_json("exchangeRates/#{utid}", params)
        end
      end
    end
  end
end
