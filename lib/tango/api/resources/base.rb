# frozen_string_literal: true

require "json"

module Tango
  module Api
    module Resources
      # Base resource providing JSON parsing and Faraday error mapping.
      class Base
        def initialize(conn)
          @conn = conn
        end

        private

        def get_json(path, params = nil)
          response = params ? @conn.get(path, params) : @conn.get(path)
          unless (200..299).cover?(response.status)
            error = Struct.new(:response).new({ status: response.status, body: response.body,
                                                headers: response.headers })
            raise map_faraday_error(error)
          end
          parse_json_response(response)
        rescue Faraday::Error => e
          raise map_faraday_error(e)
        end

        def post_json(path, body, extra_headers = nil)
          headers = { "Content-Type" => "application/json" }
          headers.merge!(extra_headers) if extra_headers
          response = @conn.post(path, body.to_json, headers)
          unless (200..299).cover?(response.status)
            error = Struct.new(:response).new({ status: response.status, body: response.body,
                                                headers: response.headers })
            raise map_faraday_error(error)
          end
          parse_json_response(response)
        rescue Faraday::Error => e
          raise map_faraday_error(e)
        end

        def patch_json(path, body, extra_headers = nil)
          headers = { "Content-Type" => "application/json" }
          headers.merge!(extra_headers) if extra_headers
          response = @conn.patch(path, body.to_json, headers)
          unless (200..299).cover?(response.status)
            error = Struct.new(:response).new({ status: response.status, body: response.body,
                                                headers: response.headers })
            raise map_faraday_error(error)
          end
          parse_json_response(response)
        rescue Faraday::Error => e
          raise map_faraday_error(e)
        end

        def delete_json(path)
          response = @conn.delete(path)
          ensure_success_or_raise(response)
          body_text = response.body.to_s
          return {} if body_text.strip.empty?

          parse_json_response(response)
        rescue Faraday::Error => e
          raise map_faraday_error(e)
        end

        def ensure_success_or_raise(response)
          return if (200..299).cover?(response.status)

          error = Struct.new(:response).new({ status: response.status, body: response.body,
                                              headers: response.headers })
          raise map_faraday_error(error)
        end

        def parse_json_response(res)
          JSON.parse(res.body)
        rescue JSON::ParserError
          { "raw" => res.body }
        end

        def map_faraday_error(error)
          status = error.response&.dig(:status)
          body = error.response&.dig(:body)
          request_id = error.response&.dig(:headers, "x-request-id")
          message, i18n_key = extract_error_message(body)

          case status
          when 401 then Errors::Unauthorized.new(message, status: status, body: body, request_id: request_id,
                                                          i18n_key: i18n_key)
          when 403 then Errors::Forbidden.new(message, status: status, body: body, request_id: request_id,
                                                       i18n_key: i18n_key)
          when 404 then Errors::NotFound.new(message, status: status, body: body, request_id: request_id,
                                                      i18n_key: i18n_key)
          when 429 then Errors::RateLimited.new(message, status: status, body: body, request_id: request_id,
                                                         i18n_key: i18n_key)
          else Errors::ServerError.new(message, status: status || 500, body: body, request_id: request_id,
                                                i18n_key: i18n_key)
          end
        end

        def extract_error_message(body)
          json = begin
            JSON.parse(body)
          rescue StandardError
            nil
          end
          return ["API Error", nil] unless json.is_a?(Hash)

          [json["message"] || "API Error", json["i18nKey"]]
        end
      end
    end
  end
end
