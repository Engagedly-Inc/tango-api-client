# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Catalogs endpoints.
      class Catalogs < Base
        # GET /catalogs with flexible params
        # Arrays are encoded as repeated keys
        def get(params = {})
          query = encode_arrays(params)
          get_json("/catalogs", query)
        end

        private

        def encode_arrays(params)
          params.transform_values do |v|
            if v.is_a?(Array)
              # Faraday will expand arrays as repeated keys when params_encoder is nil
            end
            v
          end
        end

        # encode_arrays intentionally returns arrays as-is to let Faraday repeat keys
      end
    end
  end
end
