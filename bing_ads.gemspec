# frozen_string_literal: true

require_relative "lib/bing_ads/version"

Gem::Specification.new do |spec|
  spec.name = "bing_ads"
  spec.version = BingAds::VERSION
  spec.authors = ["songji.zeng"]
  spec.email = ["songji.zeng@outlook.com"]

  spec.summary = "Unofficial Microsoft Advertising (Bing Ads) REST API client for Ruby"
  spec.description = "Unofficial Ruby SDK for the Microsoft Advertising (Bing Ads) v13 REST API, " \
                     "covering Campaign Management, Customer Management, Customer Billing, " \
                     "Ad Insight, Reporting and Bulk services with OAuth token management " \
                     "and managed async report/bulk download and upload workflows. " \
                     "Not affiliated with or endorsed by Microsoft."
  spec.homepage = "https://github.com/farainc/bing-ads-rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/farainc/bing-ads-rb"
  spec.metadata["changelog_uri"] = "https://github.com/farainc/bing-ads-rb/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base64"
  spec.add_dependency "csv"
  spec.add_dependency "net-http-persistent", "~> 4.0"
  spec.add_dependency "rubyzip", ">= 2.3", "< 4.0"
end
