# frozen_string_literal: true

require "test_helper"

class TestErrors < Minitest::Test
  FakeResponse = Struct.new(:code, :body, :headers) do
    def [](key) = headers[key]
  end

  def response(status, body, headers = {})
    FakeResponse.new(status.to_s, body, headers)
  end

  def test_hierarchy
    assert_operator BingAds::OAuthError, :<, BingAds::Error
    assert_operator BingAds::HTTPError, :<, BingAds::Error
    assert_operator BingAds::AuthenticationError, :<, BingAds::HTTPError
    assert_operator BingAds::ForbiddenError, :<, BingAds::HTTPError
    assert_operator BingAds::NotFoundError, :<, BingAds::HTTPError
    assert_operator BingAds::ValidationError, :<, BingAds::HTTPError
    assert_operator BingAds::RateLimitError, :<, BingAds::HTTPError
    assert_operator BingAds::ServerError, :<, BingAds::HTTPError
    assert_operator BingAds::OperationFailedError, :<, BingAds::Error
    assert_operator BingAds::NetworkError, :<, BingAds::Error
    refute_operator BingAds::NetworkError, :<, BingAds::HTTPError
  end

  def test_from_response_maps_status_to_subclass
    {
      400 => BingAds::ValidationError,
      401 => BingAds::AuthenticationError,
      403 => BingAds::ForbiddenError,
      404 => BingAds::NotFoundError,
      422 => BingAds::ValidationError,
      429 => BingAds::RateLimitError,
      500 => BingAds::ServerError,
      502 => BingAds::ServerError,
      503 => BingAds::ServerError,
      504 => BingAds::ServerError
    }.each do |status, klass|
      assert_instance_of klass, BingAds::HTTPError.from_response(response(status, "{}")),
                         "status #{status}"
    end
    assert_instance_of BingAds::HTTPError,
                       BingAds::HTTPError.from_response(response(418, "{}"))
  end

  def test_retryable
    assert_predicate BingAds::NetworkError.new("boom"), :retryable?
    assert_predicate BingAds::RateLimitError.new("x", status: 429), :retryable?
    assert_predicate BingAds::ServerError.new("x", status: 500), :retryable?
    refute_predicate BingAds::Error.new("x"), :retryable?
    refute_predicate BingAds::HTTPError.new("x", status: 418), :retryable?
    refute_predicate BingAds::AuthenticationError.new("x", status: 401), :retryable?
    refute_predicate BingAds::ValidationError.new("x", status: 400), :retryable?
    refute_predicate BingAds::ForbiddenError.new("x", status: 403), :retryable?
    refute_predicate BingAds::NotFoundError.new("x", status: 404), :retryable?
  end

  def test_error_attributes_are_constructor_injected
    error = BingAds::Error.new("x", retryable: true, retry_after: 9)
    assert_predicate error, :retryable?
    assert error.retryable
    assert_equal 9, error.retry_after
  end

  def test_retry_after_defaults_to_nil_on_every_error
    assert_nil BingAds::Error.new("x").retry_after
    assert_nil BingAds::NetworkError.new("x").retry_after
  end

  def test_from_response_extracts_operation_errors
    body = JSON.generate(
      "OperationErrors" => [
        { "Code" => 109, "Message" => "Authentication token expired." }
      ]
    )
    error = BingAds::HTTPError.from_response(response(401, body, "TrackingId" => "abc-123"))
    assert_equal 109, error.code
    assert_equal "Authentication token expired.", error.message
    assert_equal "abc-123", error.tracking_id
    assert_equal 401, error.status
    assert_equal 1, error.errors.length
  end

  def test_from_response_extracts_nested_fault_detail
    body = JSON.generate(
      "AdApiFaultDetail" => {
        "Errors" => [{ "Code" => 105, "Message" => "InvalidCredentials" }]
      }
    )
    error = BingAds::HTTPError.from_response(response(401, body))
    assert_equal 105, error.code
  end

  def test_from_response_tolerates_non_json_body
    error = BingAds::HTTPError.from_response(response(502, "<html>bad gateway</html>"))
    assert_equal 502, error.status
    assert_nil error.code
    assert_equal "HTTP 502", error.message
  end

  def test_from_response_parses_retry_after_seconds
    error = BingAds::HTTPError.from_response(response(429, "{}", "Retry-After" => "7"))
    assert_equal 7, error.retry_after
  end

  def test_from_response_parses_retry_after_http_date
    future = (Time.now + 42).httpdate
    error = BingAds::HTTPError.from_response(response(429, "{}", "Retry-After" => future))
    assert_includes 40..43, error.retry_after
  end

  def test_from_response_caps_retry_after
    error = BingAds::HTTPError.from_response(response(429, "{}", "Retry-After" => "86400"))
    assert_equal 300, error.retry_after
  end

  def test_from_response_tolerates_missing_or_invalid_retry_after
    assert_nil BingAds::HTTPError.from_response(response(429, "{}")).retry_after
    assert_nil BingAds::HTTPError.from_response(
      response(429, "{}", "Retry-After" => "soon")
    ).retry_after
    assert_nil BingAds::HTTPError.from_response(
      response(429, "{}", "Retry-After" => "-5")
    ).retry_after
    assert_nil BingAds::HTTPError.from_response(
      response(429, "{}", "Retry-After" => "0")
    ).retry_after
  end
end
