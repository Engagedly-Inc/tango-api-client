# frozen_string_literal: true

require "base64"

module Tango
  module Api
    module Auth
      # Basic authentication helper for Tango API.
      class Basic
        def initialize(platform:, key:)
          @platform = platform
          @key = key
        end

        def apply(headers)
          token = ::Base64.strict_encode64("#{@platform}:#{@key}")
          headers["Authorization"] = "Basic #{token}"
        end
      end
    end
  end
end
