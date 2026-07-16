# frozen_string_literal: true

require "test_helper"

class TestGoogleGrants < Minitest::Test
  GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"

  def test_google_web_grant_endpoints_and_scope
    oauth = BingAds::OAuth::GoogleWebAuthCodeGrant.new(
      client_id: "cid", client_secret: "sec", redirect_uri: "https://app.example.com/cb"
    )
    url = oauth.authorization_url
    uri = URI(url)
    params = URI.decode_www_form(uri.query).to_h
    assert_equal "accounts.google.com", uri.host
    assert_equal "/o/oauth2/v2/auth", uri.path
    assert_equal "openid email profile", params["scope"]
    assert_equal "offline", params["access_type"]
    assert_equal "Google", oauth.identity_provider
  end

  def test_google_web_grant_token_endpoint
    oauth = BingAds::OAuth::GoogleWebAuthCodeGrant.new(
      client_id: "cid", client_secret: "sec", redirect_uri: "https://app.example.com/cb"
    )
    stub = stub_request(:post, GOOGLE_TOKEN_URL)
           .with(body: hash_including("client_secret" => "sec"))
           .to_return(status: 200, body: JSON.generate(
             "access_token" => "AT", "refresh_token" => "RT", "expires_in" => 3599
           ))
    oauth.fetch_tokens(code: "C")
    assert_requested stub
  end

  def test_google_desktop_grant_requires_redirect_uri_and_uses_pkce
    oauth = BingAds::OAuth::GoogleDesktopMobileAuthCodeGrant.new(
      client_id: "cid", redirect_uri: "http://localhost:8080/cb"
    )
    assert_equal "http://localhost:8080/cb", oauth.redirect_uri
    assert_equal "Google", oauth.identity_provider
    params = URI.decode_www_form(URI(oauth.authorization_url).query).to_h
    assert params.key?("code_challenge")
    assert_equal "openid email profile", params["scope"]
  end

  def test_google_desktop_default_redirect_and_prompt
    oauth = BingAds::OAuth::GoogleDesktopMobileAuthCodeGrant.new(client_id: "cid")
    assert_equal "http://localhost", oauth.redirect_uri
    params = URI.decode_www_form(URI(oauth.authorization_url).query).to_h
    assert_equal "consent", params["prompt"]
    assert_equal "offline", params["access_type"]
  end
end
