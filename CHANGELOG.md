# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]
- Nothing yet.

## [0.1.0] - 2025-11-07
- Initial release
- Basic and OAuth2 auth strategies
- Faraday-based client with retries/timeouts and structured error mapping
- README and RSpec scaffolding
- Resources and capabilities:
  - Catalogs: `get` and convenience filters (`get_by_brand_key`, `get_by_brand_name`, `get_by_utid`, `get_by_reward_name`)
  - Orders: `create`, `get`, `list`, `resend` (supports `Idempotency-Key`)
  - Accounts: `get`, `list_for_customer`, `create`, `update_under_customer`
  - Low balance alerts under accounts: list/create/get/update/delete
  - Customers: `list`, `get`, `create`, `accounts`
  - Choice Products: `get`, `get_for_utid`, `catalog`
  - Exchange Rates: `get`, `get_for_utid`
  - Status: `get`
- Base helpers: `patch_json`, `delete_json`
- Smoke script expanded; RuboCop clean
