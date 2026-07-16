# frozen_string_literal: true

require "test_helper"

class TestOAuthAuthorization < Minitest::Test
  TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

  def auth
    BingAds::OAuth::Authorization.new(
      client_id: "cid", redirect_uri: "https://app.example.com/cb"
    )
  end

  def token_response(overrides = {})
    {
      "token_type" => "Bearer",
      "expires_in" => 3600,
      "access_token" => "AT",
      "refresh_token" => "RT"
    }.merge(overrides)
  end

  def test_authorization_url
    url = auth.authorization_url(state: "xyz")
    uri = URI(url)
    params = URI.decode_www_form(uri.query).to_h
    assert_equal "login.microsoftonline.com", uri.host
    assert_equal "/common/oauth2/v2.0/authorize", uri.path
    assert_equal "cid", params["client_id"]
    assert_equal "code", params["response_type"]
    assert_equal "https://app.example.com/cb", params["redirect_uri"]
    assert_equal "openid profile https://ads.microsoft.com/msads.manage offline_access",
                 params["scope"]
    assert_equal "xyz", params["state"]
  end

  def test_fetch_tokens_posts_code_and_stores_tokens
    stub = stub_request(:post, TOKEN_URL)
           .with(body: hash_including(
             "client_id" => "cid",
             "grant_type" => "authorization_code",
             "code" => "CODE",
             "redirect_uri" => "https://app.example.com/cb"
           ))
           .to_return(status: 200, body: JSON.generate(token_response),
                      headers: { "Content-Type" => "application/json" })

    a = auth
    tokens = a.fetch_tokens(code: "CODE")
    assert_requested stub
    assert_equal "AT", tokens.access_token
    assert_equal "RT", tokens.refresh_token
    assert_same tokens, a.tokens
  end

  def test_fetch_tokens_fires_refresh_callback
    stub_request(:post, TOKEN_URL)
      .to_return(status: 200, body: JSON.generate(token_response))
    received = nil
    a = auth
    a.on_tokens_refreshed { |t| received = t }
    a.fetch_tokens(code: "CODE")
    assert_equal "RT", received.refresh_token
  end

  def test_refresh_uses_given_refresh_token
    stub = stub_request(:post, TOKEN_URL)
           .with(body: hash_including(
             "grant_type" => "refresh_token",
             "refresh_token" => "OLD_RT"
           ))
           .to_return(status: 200, body: JSON.generate(token_response))
    auth.refresh!(refresh_token: "OLD_RT")
    assert_requested stub
  end

  def test_refresh_defaults_to_current_tokens
    stub_request(:post, TOKEN_URL)
      .to_return(status: 200, body: JSON.generate(token_response))
    a = auth
    a.fetch_tokens(code: "CODE")

    stub = stub_request(:post, TOKEN_URL)
           .with(body: hash_including("grant_type" => "refresh_token", "refresh_token" => "RT"))
           .to_return(status: 200, body: JSON.generate(token_response("access_token" => "AT2")))
    a.refresh!
    assert_requested stub
    assert_equal "AT2", a.tokens.access_token
  end

  def test_refresh_without_any_token_raises
    assert_raises(BingAds::OAuthError) { auth.refresh! }
  end

  def test_refresh_fires_callback
    stub_request(:post, TOKEN_URL)
      .to_return(status: 200, body: JSON.generate(token_response("refresh_token" => "RT2")))
    received = nil
    a = auth
    a.on_tokens_refreshed { |t| received = t }
    a.refresh!(refresh_token: "OLD_RT")
    assert_equal "RT2", received.refresh_token
  end

  def test_token_error_raises_oauth_error
    stub_request(:post, TOKEN_URL)
      .to_return(status: 400, body: JSON.generate(
        "error" => "invalid_grant", "error_description" => "expired"
      ))
    error = assert_raises(BingAds::OAuthError) { auth.fetch_tokens(code: "BAD") }
    assert_equal "invalid_grant", error.code
    assert_match(/expired/, error.message)
  end

  def test_fetch_tokens_from_response_uri
    stub = stub_request(:post, TOKEN_URL)
           .with(body: hash_including("code" => "C123"))
           .to_return(status: 200, body: JSON.generate(token_response))
    auth.fetch_tokens_from_response_uri("https://app.example.com/cb?code=C123&state=xyz")
    assert_requested stub
  end

  def test_fetch_tokens_from_response_uri_with_error_param
    error = assert_raises(BingAds::OAuthError) do
      auth.fetch_tokens_from_response_uri(
        "https://app.example.com/cb?error=access_denied&error_description=denied"
      )
    end
    assert_equal "access_denied", error.code
  end

  def test_access_token_bang_refreshes_expired_token
    a = auth
    a.tokens = BingAds::OAuth::Tokens.new(
      access_token: "OLD", refresh_token: "RT", expires_in: 3600, issued_at: Time.now - 4000
    )
    stub_request(:post, TOKEN_URL)
      .with(body: hash_including("grant_type" => "refresh_token"))
      .to_return(status: 200, body: JSON.generate(token_response("access_token" => "NEW")))
    assert_equal "NEW", a.access_token!
  end

  def test_concurrent_access_token_bang_refreshes_once
    a = auth
    a.tokens = BingAds::OAuth::Tokens.new(
      access_token: "OLD", refresh_token: "RT", expires_in: 3600, issued_at: Time.now - 4000
    )
    stub_request(:post, TOKEN_URL)
      .with(body: hash_including("grant_type" => "refresh_token"))
      .to_return(status: 200, body: JSON.generate(token_response("access_token" => "NEW")))

    tokens_seen = Array.new(8) { Thread.new { a.access_token! } }.map(&:value)
    assert_equal ["NEW"], tokens_seen.uniq
    assert_requested :post, TOKEN_URL, times: 1
  end

  def test_access_token_bang_without_tokens_raises
    assert_raises(BingAds::OAuthError) { auth.access_token! }
  end

  def test_identity_provider_is_nil
    assert_nil auth.identity_provider
  end
end
