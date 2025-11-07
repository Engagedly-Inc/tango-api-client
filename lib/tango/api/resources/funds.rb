# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Funds endpoints.
      class Funds < Base
        # POST /funds/registerCreditCard
        def register_card(body)
          post_json("/funds/registerCreditCard", body)
        end

        # POST /funds/unregisterCreditCard
        def unregister_card(body)
          post_json("/funds/unregisterCreditCard", body)
        end

        # POST /funds/add
        def add_funds(body)
          post_json("/funds/add", body)
        end
      end
    end
  end
end
