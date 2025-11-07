# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/object/blank"
require "logger"

module Tango
  # Root namespace for the Tango API Ruby client.
  module Api
    # Configuration entry point for the Tango API client.
    class << self
      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end
    end

    # Holds client-wide configuration such as timeouts, retries and auth.
    class Configuration
      attr_accessor :base_url, :timeout, :open_timeout, :retries, :logger, :default_headers, :auth

      def initialize
        @base_url = ENV["TANGO_URL"].to_s.presence
        @timeout = 45
        @open_timeout = 5
        @retries = { max: 2, base: 0.5, max_delay: 5 }
        @logger = defined?(Rails) ? Rails.logger : Logger.new($stdout)
        @default_headers = { "Accept" => "application/json" }
        @auth = nil
      end
    end
  end
end
