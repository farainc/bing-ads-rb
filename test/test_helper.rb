# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bing_ads"

require "minitest/autorun"
require "webmock/minitest"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }
