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

        # Convenience: filter by brandKey
        def get_by_brand_key(brand_key, params = {})
          get(params.merge(brandKey: brand_key))
        end

        # Convenience: filter by brandName
        def get_by_brand_name(brand_name, params = {})
          get(params.merge(brandName: brand_name))
        end

        # Convenience: filter by utid
        def get_by_utid(utid, params = {})
          get(params.merge(utid: utid))
        end

        # Convenience: filter by rewardName
        def get_by_reward_name(reward_name, params = {})
          get(params.merge(rewardName: reward_name))
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
