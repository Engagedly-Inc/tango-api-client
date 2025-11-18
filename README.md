# tango-api-client

Ruby client for Tango (BHN) API with dual auth (Basic/OAuth2), flexible parameterization, retries/timeouts, and structured errors.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add tango-api-client
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install tango-api-client
```

## Usage

```ruby
require "tango/api/client"

Tango::Api.configure do |c|
  c.base_url = ENV["TANGO_URL"]
  c.timeout = 45
  c.retries = { max: 2, base: 0.5, max_delay: 5 }
  # Basic auth
  c.auth = Tango::Api::Auth::Basic.new(platform: ENV["TANGO_PLATFORM"], key: ENV["TANGO_KEY"])
  # or OAuth2
  # c.auth = Tango::Api::Auth::OAuth2.new(
  #   token_url: ENV["TANGO_TOKEN_URL"],
  #   client_id: ENV["TANGO_CLIENT_ID"],
  #   client_secret: ENV["TANGO_CLIENT_SECRET"],
  #   scope: ENV["TANGO_SCOPE"]
  # )
end

client = Tango::Api::Client.new

# Alternatively, pass a base URL string directly
# (convenient for scripts or isolated clients)
client = Tango::Api::Client.new("https://integration-api.tangocard.com/raas/v2")

# Or pass a configuration hash for explicit per-client settings
client = Tango::Api::Client.new(
  base_url: "https://integration-api.tangocard.com/raas/v2",
  timeout: 60,
  retries: { max: 3, base: 0.5, max_delay: 8 },
  default_headers: { "Accept-Language" => "en-US" }
)

# Catalogs
client.catalogs.get(country: 'US', status: 'active', verbose: true, rewardType: ['gift card','payment card'], categoryIds: 'uuid1,uuid2', currency: 'USD')

# Orders
client.orders.create(accountIdentifier: 'acc', amount: 1000, customerIdentifier: 'cust', utid: 'UT...', recipient: { email: 'a@b.com', firstName: 'A' }, sendEmail: true)

# Accounts
client.accounts.get('acc-identifier')

# Create Account for a Customer
client.accounts.create('customer-identifier', { accountIdentifier: 'new-acc', currency: 'USD' })

# Customers
client.customers.create({ customerIdentifier: 'cust', name: 'ACME Inc.' })
# List and filter customers
client.customers.list(displayName: 'ACME', status: 'active')
# Fetch a specific customer
client.customers.get('cust')

# Funds
client.funds.register_card({ accountIdentifier: 'acc', card: { number: '4111...', expiryMonth: '12', expiryYear: '2030' } })
client.funds.add_funds({ accountIdentifier: 'acc', amount: 5000 })
client.funds.unregister_card({ accountIdentifier: 'acc' })

# Error handling
begin
  client.accounts.get('missing')
rescue Tango::Api::Errors::HttpError => e
  puts "Error: #{e.class} status=#{e.status} request_id=#{e.request_id} message=#{e.message}"
end
```

### Notes
- Retries apply to idempotent HTTP methods (GET/HEAD/OPTIONS) with backoff and jitter.
- Ruby >= 3.0 is required.
- `base_url` is required (e.g., `https://api.tangocard.com/raas/v2`).
- Initialization options:
  - Global config (recommended for Rails/apps): use `Tango::Api.configure { ... }` then `Tango::Api::Client.new`.
  - Per-client overrides: pass a config hash to `Client.new(...)`.
  - Convenience: passing a base URL string to `Client.new("https://...")` is supported for quick scripts.

### Examples

```ruby
# Catalogs convenience filters
client.catalogs.get_by_brand_key('AMAZON', verbose: true)
client.catalogs.get_by_brand_name('Amazon', country: 'US')
client.catalogs.get_by_utid('UT123456')
client.catalogs.get_by_reward_name('Gift Card')

# Choice Products
client.choice_products.get(rewardName: 'Choice', currencyCode: 'USD', countries: ['US'])
client.choice_products.get_for_utid('UT-CHOICE-123')
client.choice_products.catalog('UT-CHOICE-123', verbose: true, country: 'US')

# Orders with Idempotency-Key for safe retries
require 'securerandom'
idempotency = SecureRandom.uuid
client.orders.create(
  { accountIdentifier: 'acc', amount: 1000, customerIdentifier: 'cust', utid: 'UT123', recipient: { email: 'a@b.com' } },
  idempotency_key: idempotency
)

# Resend with Idempotency-Key (prevents duplicate resends)
client.orders.resend('ORDER-123', idempotency_key: idempotency)
```

### Resources overview

| Resource  | Class                             | Methods (args)                                                                        | HTTP / Path                                        |
|-----------|-----------------------------------|----------------------------------------------------------------------------------------|----------------------------------------------------|
| Catalogs  | `Tango::Api::Resources::Catalogs` | `get(params = {})`                                                                     | GET `/catalogs`                                    |
| Brand Categories | `Tango::Api::Resources::BrandCategories` | `get`                                                                                  | GET `/brandCategories`                            |
| Orders    | `Tango::Api::Resources::Orders`   | `create(body)`, `get(order_id)`, `list(params = {})`, `resend(order_id)`               | POST `/orders`; GET `/orders/{id}`; GET `/orders`; POST `/orders/{id}/resend` |
| Accounts  | `Tango::Api::Resources::Accounts` | `get(account_identifier)`, `list_for_customer(customer_identifier, params)`, `create(customer_identifier, body)`, `update_under_customer(customer_identifier, account_identifier, body)`, low balance alerts: `list_low_balance_alerts`, `set_low_balance_alert`, `get_low_balance_alert`, `update_low_balance_alert`, `delete_low_balance_alert` | GET `/accounts/{accountIdentifier}`; GET/POST/PATCH/DELETE under `/customers/{customerIdentifier}/accounts/...` |
| Customers | `Tango::Api::Resources::Customers`| `list(params = {})`, `get(customer_identifier)`, `create(body)`, `accounts(customer_identifier, params)` | GET `/customers`; GET `/customers/{customerIdentifier}`; POST `/customers`; GET `/customers/{customerIdentifier}/accounts` |
| Funds     | `Tango::Api::Resources::Funds`    | `register_card(body)`, `unregister_card(body)`, `add_funds(body)`                      | POST `/funds/registerCreditCard`; `/funds/unregisterCreditCard`; `/funds/add` |
| Status    | `Tango::Api::Resources::Status`   | `get`                                                                                  | GET `/status`                                      |
| Exchange Rates | `Tango::Api::Resources::ExchangeRates` | `get(params = {})`, `get_for_utid(utid, params = {})`                            | GET `/exchangeRates`; GET `/exchangeRates/{utid}`  |
| Choice Products | `Tango::Api::Resources::ChoiceProducts` | `get(params = {})`, `get_for_utid(utid)`, `catalog(choice_product_utid, params = {})` | GET `/choiceProducts`; GET `/choiceProducts/{utid}`; GET `/choiceProducts/{utid}/catalog` |

### Smoke test

Run a basic end-to-end check against your Tango environment.

Required:

```bash
export TANGO_URL=https://integration-api.tangocard.com/raas/v2
export TANGO_PLATFORM=QAPlatform2
export TANGO_KEY=YOUR_BASIC_KEY
```

Run:

```bash
bin/smoke
```

Optional flags:

- SMOKE_RUN_STATUS=true: call `/status` (may be 404 on RAAS v2)
- SMOKE_RUN_EXCHANGE_RATES=true: call `/exchangerates`
- TANGO_RUN_MUTATIONS=true: enable POST flows (create/update/delete)

Optional data variables (used when present):

- TANGO_ACCOUNT_IDENTIFIER, TANGO_CUSTOMER_IDENTIFIER
- TANGO_ORDER_IDENTIFIER, TANGO_ORDER_AMOUNT (default 100)
- TANGO_UTID or TANGO_CHOICE_PRODUCT_UTID for order/choice product flows
- TANGO_RECIPIENT_EMAIL
- Low balance alerts:
  - TANGO_LOW_BALANCE_ALERT_BODY (JSON) or individual fields:
  - TANGO_LOW_BALANCE_ALERT_DISPLAY_NAME, TANGO_LOW_BALANCE_ALERT_THRESHOLD, TANGO_LOW_BALANCE_ALERT_EMAIL

At the end, the script prints a summary of passed/failed checks with statuses and messages.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Engagedly-Inc/tango-api-client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
