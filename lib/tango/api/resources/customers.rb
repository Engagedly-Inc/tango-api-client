# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Customers endpoints.
      class Customers < Base
        # POST /customers
        def create(body)
          post_json("/customers", body)
        end
      end
    end
  end
end
