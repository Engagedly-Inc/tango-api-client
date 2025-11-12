# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Resource for exchange rates across catalog items and currencies.
      class ExchangeRates < Base
        # GET /exchangerates
        # Example params: { currency: 'USD', country: 'US' }
        def get(params = {})
          get_json("exchangerates", params)
        end

        # GET /exchangerates/{utid}
        # Fetch exchange rate info for a specific catalog item by UTID.
        def get_for_utid(utid, params = {})
          get_json("exchangerates/#{utid}", params)
        end
      end
    end
  end
end
