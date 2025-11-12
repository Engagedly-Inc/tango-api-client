# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Accounts endpoints.
      class Accounts < Base
        # GET /customers/{customerIdentifier}/accounts
        def list_for_customer(customer_identifier, params = {})
          get_json("customers/#{customer_identifier}/accounts", params)
        end

        # GET /accounts/{accountIdentifier}
        def get(account_identifier)
          get_json("accounts/#{account_identifier}")
        end

        # POST /customers/{customerIdentifier}/accounts
        def create(customer_identifier, body)
          post_json("customers/#{customer_identifier}/accounts", body)
        end

        # PATCH /customers/{customerIdentifier}/accounts/{accountIdentifier}
        def update_under_customer(customer_identifier, account_identifier, body)
          patch_json("customers/#{customer_identifier}/accounts/#{account_identifier}", body)
        end

        # Low balance alerts
        # GET /customers/{customerIdentifier}/accounts/{accountIdentifier}/lowbalance
        def list_low_balance_alerts(customer_identifier, account_identifier)
          get_json("customers/#{customer_identifier}/accounts/#{account_identifier}/lowbalance")
        end

        # POST /customers/{customerIdentifier}/accounts/{accountIdentifier}/lowbalance
        def set_low_balance_alert(customer_identifier, account_identifier, body)
          post_json("customers/#{customer_identifier}/accounts/#{account_identifier}/lowbalance", body)
        end

        # GET /customers/{customerIdentifier}/accounts/{accountIdentifier}/lowbalance/{alertIdentifier}
        def get_low_balance_alert(customer_identifier, account_identifier, alert_identifier)
          path = "customers/#{customer_identifier}/accounts/#{account_identifier}/lowbalance/#{alert_identifier}"
          get_json(path)
        end

        # PATCH /customers/{customerIdentifier}/accounts/{accountIdentifier}/lowbalance/{alertIdentifier}
        def update_low_balance_alert(customer_identifier, account_identifier, alert_identifier, body)
          path = "customers/#{customer_identifier}/accounts/#{account_identifier}/lowbalance/#{alert_identifier}"
          patch_json(path, body)
        end

        # DELETE /customers/{customerIdentifier}/accounts/{accountIdentifier}/lowbalance/{alertIdentifier}
        def delete_low_balance_alert(customer_identifier, account_identifier, alert_identifier)
          path = "customers/#{customer_identifier}/accounts/#{account_identifier}/lowbalance/#{alert_identifier}"
          delete_json(path)
        end
      end
    end
  end
end
