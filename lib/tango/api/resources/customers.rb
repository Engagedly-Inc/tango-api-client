# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Customers endpoints.
      class Customers < Base
        # GET /customers
        def list(params = {})
          get_json("customers", params)
        end

        # GET /customers/{customerIdentifier}
        def get(customer_identifier)
          get_json("customers/#{customer_identifier}")
        end

        # POST /customers
        def create(body)
          post_json("customers", body)
        end

        # GET /customers/{customerIdentifier}/accounts
        def accounts(customer_identifier, params = {})
          get_json("customers/#{customer_identifier}/accounts", params)
        end
      end
    end
  end
end
