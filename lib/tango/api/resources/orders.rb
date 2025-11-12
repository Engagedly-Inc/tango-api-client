# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Client for Orders endpoints.
      class Orders < Base
        # POST /orders
        def create(body, idempotency_key: nil)
          headers = idempotency_key ? { "Idempotency-Key" => idempotency_key } : nil
          post_json("orders", body, headers)
        end

        # GET /orders/{referenceOrderID}
        def get(order_id)
          get_json("orders/#{order_id}")
        end

        # GET /orders
        def list(params = {})
          get_json("orders", params)
        end

        # POST /orders/{order_id}/resend
        def resend(order_id, idempotency_key: nil)
          headers = idempotency_key ? { "Idempotency-Key" => idempotency_key } : nil
          post_json("orders/#{order_id}/resend", {}, headers)
        end
      end
    end
  end
end
