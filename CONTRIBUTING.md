## Contributing to tango-api-client

Thanks for helping improve this gem! This guide explains how to set up your environment, run tests, lint the code, and propose changes.

### Prerequisites
- Ruby 3.0+ (tested on 3.0–3.3)
- Bundler

### Setup
```bash
git clone https://github.com/Engagedly-Inc/tango-api-client.git
cd tango-api-client
bin/setup
```

### Running the test suite and linters
```bash
bundle exec rake spec
bundle exec rubocop
```

Optional: run the smoke script (read the file for env vars and opt-ins)
```bash
ruby bin/smoke
```

### Development workflow
1. Create a branch from `master`.
2. Make focused changes (with tests where applicable).
3. Ensure `rake spec` and `rubocop` pass locally.
4. Update `README.md` or `CHANGELOG.md` if behavior changes or new endpoints are added.
5. Open a pull request describing:
   - What changed and why
   - Any breaking changes
   - How to test/verify

### Versioning and releases
- Maintainers bump the version in `lib/tango/api/client/version.rb` and update `CHANGELOG.md`.
- Releasing is done via:
  ```bash
  bundle exec rake release
  ```
  This tags the repo and pushes the gem to RubyGems (requires RubyGems API key and MFA).

### Code style
- Ruby style is enforced with RuboCop (see `.rubocop.yml`).
- Prefer small, composable methods and clear names.
- Avoid duplicating API validations; rely on server responses unless a simple presence check clearly improves developer experience.

### Security
- Do not include secrets or tokens in commits, logs, or examples.
- Report security issues privately via GitHub Security Advisories.

### Questions and support
- Open a “Question” issue if something is unclear.
- PRs are welcome—thanks for contributing!


