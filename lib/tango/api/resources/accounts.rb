# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Accounts endpoints.
      class Accounts < Base
        # GET /accounts/{accountIdentifier}
        def get(account_identifier)
          get_json("/accounts/#{account_identifier}")
        end

        # POST /customers/{customerIdentifier}/accounts
        def create(customer_identifier, body)
          post_json("/customers/#{customer_identifier}/accounts", body)
        end
      end
    end
  end
end
