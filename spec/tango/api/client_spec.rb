# frozen_string_literal: true

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
end
