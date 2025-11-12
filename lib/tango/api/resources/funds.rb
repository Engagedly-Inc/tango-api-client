# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Funds endpoints.
      class Funds < Base
        # GET /creditCards
        # Optional params: { customerIdentifier:, accountIdentifier:, ... } (varies by tenant)
        def list_cards(params = {})
          get_json("creditCards", params)
        end

        # GET /creditCards/{creditCardToken}
        def get_card(credit_card_token)
          get_json("creditCards/#{credit_card_token}")
        end

        # POST /creditCards
        def register_card(body)
          post_json("creditCards", body)
        end

        # POST /creditCardUnregisters
        # Body: { customerIdentifier:, accountIdentifier:, creditCardToken: }
        def unregister_card(body)
          post_json("creditCardUnregisters", body)
        end

        # POST /creditCardDeposits
        # Body requires: customerIdentifier, accountIdentifier, externalRefID, creditCardToken, amount
        def create_credit_card_deposit(body)
          post_json("creditCardDeposits", body)
        end

        # GET /creditCardDeposits/{externalRefID}
        def get_credit_card_deposit(external_ref_id)
          get_json("creditCardDeposits/#{external_ref_id}")
        end
      end
    end
  end
end
