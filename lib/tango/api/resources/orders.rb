# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Orders endpoints.
      class Orders < Base
        # POST /orders
        def create(body)
          post_json("/orders", body)
        end
      end
    end
  end
end
