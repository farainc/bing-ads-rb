# frozen_string_literal: true

require "test_helper"

class TestConnection < Minitest::Test
  URL = "https://campaign.api.bingads.microsoft.com/CampaignManagement/v13/Campaigns"

  def connection(**)
    @sleeps = []
    BingAds::Connection.new(sleeper: ->(s) { @sleeps << s }, **)
  end

  def test_success_parses_json
    stub_request(:post, URL)
      .with(
        body: JSON.generate("AccountId" => "456"),
        headers: { "Content-Type" => "application/json", "DeveloperToken" => "DT" }
      )
      .to_return(status: 200, body: JSON.generate("CampaignIds" => ["1"]))
    result = connection.request(:post, URL, headers: { "DeveloperToken" => "DT" },
                                            body: { "AccountId" => "456" })
    assert_equal({ "CampaignIds" => ["1"] }, result)
  end

  def test_sends_user_agent
    stub = stub_request(:post, URL)
           .with(headers: { "User-Agent" => BingAds::Connection::USER_AGENT })
           .to_return(status: 200, body: "{}")
    connection.request(:post, URL, body: {})
    assert_requested stub
  end

  def test_empty_body_returns_nil
    stub_request(:delete, URL).to_return(status: 200, body: "")
    assert_nil connection.request(:delete, URL)
  end

  def test_retries_500_then_succeeds
    stub_request(:post, URL)
      .to_return({ status: 500, body: "{}" }, { status: 200, body: JSON.generate("Ok" => true) })
    result = connection.request(:post, URL, body: {})
    assert_equal({ "Ok" => true }, result)
    assert_equal 1, @sleeps.length
    assert_operator @sleeps.first, :>=, 1.0 # exponential floor for attempt 1
  end

  def test_gives_up_after_max_retries_and_raises_server_error
    stub_request(:post, URL).to_return(status: 500, body: "{}")
    assert_raises(BingAds::ServerError) do
      connection(max_retries: 2).request(:post, URL, body: {})
    end
    assert_equal 2, @sleeps.length
  end

  def test_honors_retry_after_header
    stub_request(:post, URL)
      .to_return({ status: 429, body: "{}", headers: { "Retry-After" => "7" } },
                 { status: 200, body: "{}" })
    connection.request(:post, URL, body: {})
    assert_equal [7], @sleeps
  end

  def test_retries_network_errors
    stub_request(:post, URL).to_raise(Errno::ECONNRESET)
                            .then.to_return(status: 200, body: "{}")
    assert_equal({}, connection.request(:post, URL, body: {}))
    assert_equal 1, @sleeps.length
  end

  def test_caps_retry_after
    stub_request(:post, URL)
      .to_return({ status: 429, body: "{}", headers: { "Retry-After" => "86400" } },
                 { status: 200, body: "{}" })
    connection.request(:post, URL, body: {})
    assert_equal [300], @sleeps
  end

  def test_unsupported_method_raises_argument_error
    assert_raises(ArgumentError) { connection.request(:brew, URL) }
  end

  def test_network_error_carries_cause
    stub_request(:post, URL).to_raise(Errno::ECONNRESET)
    error = assert_raises(BingAds::NetworkError) do
      connection(max_retries: 0).request(:post, URL, body: {})
    end
    assert_instance_of Errno::ECONNRESET, error.cause
  end

  def test_network_error_exhaustion_raises_typed_error_with_cause
    stub_request(:post, URL).to_raise(Errno::ECONNRESET)
    error = assert_raises(BingAds::NetworkError) do
      connection(max_retries: 1).request(:post, URL, body: {})
    end
    assert_instance_of Errno::ECONNRESET, error.cause
    assert_equal 1, @sleeps.length
  end

  def test_client_error_raises_mapped_error_without_retry
    stub_request(:post, URL).to_return(
      status: 401,
      body: JSON.generate("OperationErrors" => [{ "Code" => 109, "Message" => "expired" }]),
      headers: { "TrackingId" => "tid" }
    )
    error = assert_raises(BingAds::AuthenticationError) do
      connection.request(:post, URL, body: {})
    end
    assert_equal 109, error.code
    assert_equal "tid", error.tracking_id
    assert_empty @sleeps
  end

  def test_exhausted_retries_surface_retry_after_on_the_raised_error
    stub_request(:post, URL)
      .to_return(status: 503, body: "{}", headers: { "Retry-After" => "7" })
    error = assert_raises(BingAds::ServerError) do
      connection(max_retries: 1).request(:post, URL, body: {})
    end
    assert_equal 7, error.retry_after
    assert_equal [7], @sleeps
  end

  def test_persistent_error_is_wrapped_as_network_error
    stub_request(:post, URL).to_raise(Net::HTTP::Persistent::Error)
    error = assert_raises(BingAds::NetworkError) do
      connection(max_retries: 0).request(:post, URL, body: {})
    end
    assert_instance_of Net::HTTP::Persistent::Error, error.cause
  end
end
