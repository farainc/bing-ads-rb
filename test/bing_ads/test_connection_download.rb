# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class TestConnectionDownload < Minitest::Test
  URL = "https://bulk.api.bingads.microsoft.com/files/result.zip"

  def connection
    @sleeps = []
    BingAds::Connection.new(sleeper: ->(s) { @sleeps << s })
  end

  def test_downloads_binary_body_to_file
    stub_request(:get, URL).to_return(status: 200, body: "PK\x03\x04binary".b)
    Dir.mktmpdir do |dir|
      path = File.join(dir, "r.zip")
      assert_equal path, connection.download(URL, to: path)
      assert_equal "PK\x03\x04binary".b, File.binread(path)
    end
  end

  def test_raises_on_http_error
    stub_request(:get, URL).to_return(status: 404, body: "{}")
    Dir.mktmpdir do |dir|
      assert_raises(BingAds::NotFoundError) do
        connection.download(URL, to: File.join(dir, "r.zip"))
      end
    end
  end

  def test_failed_download_leaves_no_partial_file
    stub_request(:get, URL).to_return(status: 404, body: "{}")
    Dir.mktmpdir do |dir|
      path = File.join(dir, "r.zip")
      assert_raises(BingAds::NotFoundError) { connection.download(URL, to: path) }
      refute File.exist?(path)
      refute File.exist?("#{path}.part")
    end
  end

  def test_streams_large_body
    big = "x" * (5 * 1024 * 1024)
    stub_request(:get, URL).to_return(status: 200, body: big)
    Dir.mktmpdir do |dir|
      path = File.join(dir, "big.zip")
      connection.download(URL, to: path)
      assert_equal big.bytesize, File.size(path)
      refute File.exist?("#{path}.part")
    end
  end

  def test_retries_server_errors
    stub_request(:get, URL)
      .to_return({ status: 503, body: "{}" }, { status: 200, body: "ok" })
    Dir.mktmpdir do |dir|
      path = File.join(dir, "r.zip")
      connection.download(URL, to: path)
      assert_equal "ok", File.read(path)
      assert_equal 1, @sleeps.length
    end
  end
end
