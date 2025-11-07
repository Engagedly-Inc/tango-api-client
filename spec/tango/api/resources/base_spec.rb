# frozen_string_literal: true

require "spec_helper"
require "faraday"
require "json"

require "tango/api/client"

# rubocop:disable Metrics/BlockLength
RSpec.describe Tango::Api::Resources::Base do
  let(:conn) do
    # Fake Faraday connection with a simple adapter
    Faraday.new do |f|
      f.adapter :test do |stub|
        stub.get("/ok") { |_env| [200, {}, { ok: true }.to_json] }
        stub.get("/bad_json") { |_env| [200, {}, "{not-json}"] }
        stub.get("/fail") { |_env| [401, { "x-request-id" => "rid-1" }, { message: "nope", i18nKey: "auth" }.to_json] }
        stub.post("/echo") { |env| [200, {}, env.body] }
      end
    end
  end

  let(:resource) { described_class.new(conn) }

  it "parses valid JSON" do
    res = resource.send(:get_json, "/ok")
    expect(res).to eq("ok" => true)
  end

  it "returns raw body for invalid JSON" do
    res = resource.send(:get_json, "/bad_json")
    expect(res).to eq("raw" => "{not-json}")
  end

  it "maps non-success responses to typed errors" do
    expect { resource.send(:get_json, "/fail") }.to raise_error(Tango::Api::Errors::Unauthorized) do |err|
      expect(err.status).to eq(401)
      expect(err.request_id).to eq("rid-1")
      expect(err.i18n_key).to eq("auth")
    end
  end

  it "posts JSON and parses response" do
    res = resource.send(:post_json, "/echo", { a: 1 })
    expect(res).to eq("a" => 1)
  end
end

# rubocop:enable Metrics/BlockLength
