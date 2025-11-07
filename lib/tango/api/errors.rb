# frozen_string_literal: true

module Tango
  module Api
    module Errors
      # Base HTTP error carrying status, body, request id and optional i18n key.
      class HttpError < StandardError
        attr_reader :status, :body, :request_id, :i18n_key

        def initialize(message, status:, body: nil, request_id: nil, i18n_key: nil)
          super(message)
          @status = status
          @body = body
          @request_id = request_id
          @i18n_key = i18n_key
        end
      end

      class Unauthorized < HttpError; end
      class Forbidden < HttpError; end
      class NotFound < HttpError; end
      class RateLimited < HttpError; end
      class ServerError < HttpError; end
    end
  end
end
