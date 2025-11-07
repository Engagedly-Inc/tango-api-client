# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "logger"

module Tango
  module Api
    module Auth
      # OAuth2 client credentials flow helper that injects Bearer tokens.
      class OAuth2
        Token = Struct.new(:access_token, :expires_at)

        def initialize(token_url:, client_id:, client_secret:, scope: nil, logger: nil)
          @token_url = token_url
          @client_id = client_id
          @client_secret = client_secret
          @scope = scope
          @logger = logger || (defined?(Rails) ? Rails.logger : Logger.new($stdout))
          @mutex = Mutex.new
          @token = nil
        end

        def apply(headers)
          token = fetch_token
          headers["Authorization"] = "Bearer #{token}"
        end

        private

        def fetch_token
          @mutex.synchronize do
            return @token.access_token if @token && Time.now < (@token.expires_at - 60)

            uri = URI(@token_url)
            req = Net::HTTP::Post.new(uri)
            req["Content-Type"] = "application/x-www-form-urlencoded"
            body = {
              grant_type: "client_credentials",
              client_id: @client_id,
              client_secret: @client_secret
            }
            body[:scope] = @scope if @scope
            req.body = URI.encode_www_form(body)

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = uri.scheme == "https"
            http.read_timeout = 10
            http.open_timeout = 5
            res = http.request(req)

            unless res.is_a?(Net::HTTPSuccess)
              @logger.error "OAuth2 token request failed: #{res.code} #{res.body}"
              raise StandardError, "OAuth2 token request failed with #{res.code}"
            end

            data = JSON.parse(res.body)
            expires_in = (data["expires_in"] || 3600).to_i
            @token = Token.new(data["access_token"], Time.now + expires_in)
            @token.access_token
          end
        end
      end
    end
  end
end
