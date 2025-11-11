# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe Tango::Api::Client do
  it "has a version number" do
    expect(Tango::Api::Client::VERSION).not_to be nil
  end

  it "builds without configuration errors" do
    Tango::Api.configure do |c|
      c.base_url = "https://api.tango.com"
      c.auth = nil
    end
    client = described_class.new
    expect(client).to be_a(described_class)
  end

  it "raises when base_url is blank" do
    Tango::Api.configure do |c|
      c.base_url = nil
      c.auth = nil
    end
    expect { described_class.new }.to raise_error(ArgumentError, /base_url is required/)
  end

  it "configures Faraday retry middleware" do
    Tango::Api.configure do |c|
      c.base_url = "https://api.tango.com"
      c.auth = nil
    end
    client = described_class.new
    handlers = client.instance_variable_get(:@conn).builder.handlers
    expect(handlers).to include(Faraday::Request::Retry)
  end

  it "exposes new resources and methods for parity" do
    Tango::Api.configure do |c|
      c.base_url = "https://api.tango.com"
      c.auth = nil
    end
    client = described_class.new
    expect(client).to respond_to(:status)
    expect(client).to respond_to(:exchange_rates)

    orders = client.orders
    expect(orders).to respond_to(:get)
    expect(orders).to respond_to(:list)
    expect(orders).to respond_to(:resend)
  end
end
# rubocop:enable Metrics/BlockLength
