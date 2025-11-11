# frozen_string_literal: true

require "faraday"
require "faraday/follow_redirects"
require "faraday/retry"
require "json"

require_relative "client/version"
require_relative "../api"
require_relative "errors"
require_relative "auth/basic"
require_relative "auth/oauth2"
require_relative "resources/base"
require_relative "resources/catalogs"
require_relative "resources/accounts"
require_relative "resources/orders"
require_relative "resources/funds"
require_relative "resources/customers"
require_relative "resources/status"
require_relative "resources/exchange_rates"

module Tango
  module Api
    # Public client to interact with Tango API resources via Faraday.
    class Client
      def initialize(config = Tango::Api.configuration)
        @config = config
        raise ArgumentError, "Tango::Api.configuration.base_url is required" if @config.base_url.to_s.strip.empty?

        @conn = build_connection
      end

      def catalogs
        Resources::Catalogs.new(@conn)
      end

      def accounts
        Resources::Accounts.new(@conn)
      end

      def orders
        Resources::Orders.new(@conn)
      end

      def funds
        Resources::Funds.new(@conn)
      end

      def customers
        Resources::Customers.new(@conn)
      end

      def status
        Resources::Status.new(@conn)
      end

      def exchange_rates
        Resources::ExchangeRates.new(@conn)
      end

      private

      def build_connection
        Faraday.new(url: @config.base_url, headers: default_headers) do |f|
          f.request :url_encoded
          f.response :follow_redirects
          f.options.timeout = @config.timeout
          f.options.open_timeout = @config.open_timeout

          f.request :retry, retry_options

          f.response :raise_error
          f.adapter Faraday.default_adapter
        end
      end

      def default_headers
        headers = (@config.default_headers || {}).dup
        apply_auth(headers)
        headers
      end

      def apply_auth(headers)
        return unless @config.auth

        @config.auth.apply(headers)
      end

      def retry_options
        max = @config.retries[:max] || 2
        base = @config.retries[:base] || 0.5
        max_delay = @config.retries[:max_delay] || 5
        {
          max: max,
          interval: base,
          interval_randomness: 0.5,
          backoff_factor: 2,
          max_interval: max_delay,
          retry_statuses: [429, 500, 502, 503, 504],
          methods: %i[get head options]
        }
      end
    end

    # Namespace for resource-specific wrappers.
    module Resources; end
  end
end
