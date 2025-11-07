# frozen_string_literal: true

require_relative "lib/tango/api/client/version"

Gem::Specification.new do |spec|
  spec.name = "tango-api-client"
  spec.version = Tango::Api::Client::VERSION
  spec.authors = ["Puneeth Kumar DN"]
  spec.email = ["puneeth@engagedly.com"]

  spec.summary = "Ruby client for Tango (BHN) API with dual auth and robust errors."
  spec.description = "Client for Tango API with Basic/OAuth2, flexible params, retries and structured errors."
  spec.homepage = "https://github.com/Engagedly-Inc/tango-api-client"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  # spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Engagedly-Inc/tango-api-client"
  spec.metadata["changelog_uri"] = "https://github.com/Engagedly-Inc/tango-api-client/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency "faraday", ">= 2.7"
  spec.add_dependency "faraday-follow_redirects", ">= 0.3"
  spec.add_dependency "faraday-retry", ">= 2.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
