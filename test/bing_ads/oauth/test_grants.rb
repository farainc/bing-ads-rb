# frozen_string_literal: true

require "test_helper"
require "digest"
require "base64"

class TestGrants < Minitest::Test
  TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

  def token_body
    JSON.generate("access_token" => "AT", "refresh_token" => "RT", "expires_in" => 3600)
  end

  def test_web_grant_sends_client_secret
    oauth = BingAds::OAuth::WebAuthCodeGrant.new(
      client_id: "cid", client_secret: "sec", redirect_uri: "https://app.example.com/cb"
    )
    stub = stub_request(:post, TOKEN_URL)
           .with(body: hash_including("client_secret" => "sec", "code" => "C"))
           .to_return(status: 200, body: token_body)
    oauth.fetch_tokens(code: "C")
    assert_requested stub
  end

  def test_desktop_grant_defaults_to_native_redirect_uri
    oauth = BingAds::OAuth::DesktopMobileAuthCodeGrant.new(client_id: "cid")
    assert_equal "https://login.microsoftonline.com/common/oauth2/nativeclient",
                 oauth.redirect_uri
  end

  def test_desktop_grant_pkce_challenge_in_authorization_url
    oauth = BingAds::OAuth::DesktopMobileAuthCodeGrant.new(client_id: "cid")
    params = URI.decode_www_form(URI(oauth.authorization_url).query).to_h
    expected = Base64.urlsafe_encode64(Digest::SHA256.digest(oauth.code_verifier), padding: false)
    assert_equal expected, params["code_challenge"]
    assert_equal "S256", params["code_challenge_method"]
  end

  def test_desktop_grant_sends_code_verifier_not_secret
    oauth = BingAds::OAuth::DesktopMobileAuthCodeGrant.new(client_id: "cid")
    stub = stub_request(:post, TOKEN_URL)
           .with do |req|
             req.body.include?("code_verifier=#{oauth.code_verifier}") &&
               !req.body.include?("client_secret")
           end
           .to_return(status: 200, body: token_body)
    oauth.fetch_tokens(code: "C")
    assert_requested stub
  end

  def test_tenant_substitutes_common_on_microsoft_grants
    web = BingAds::OAuth::WebAuthCodeGrant.new(
      client_id: "cid", client_secret: "sec",
      redirect_uri: "https://app.example.com/cb", tenant: "contoso.example"
    )
    assert_includes web.authorization_url, "login.microsoftonline.com/contoso.example/oauth2"

    stub = stub_request(:post, "https://login.microsoftonline.com/contoso.example/oauth2/v2.0/token")
           .to_return(status: 200, body: token_body)
    web.fetch_tokens(code: "C")
    assert_requested stub

    desktop = BingAds::OAuth::DesktopMobileAuthCodeGrant.new(client_id: "cid", tenant: "contoso.example")
    assert_includes desktop.authorization_url, "/contoso.example/oauth2/v2.0/authorize"
  end

  def test_desktop_grant_pkce_can_be_disabled
    oauth = BingAds::OAuth::DesktopMobileAuthCodeGrant.new(client_id: "cid", pkce: false)
    assert_nil oauth.code_verifier
    params = URI.decode_www_form(URI(oauth.authorization_url).query).to_h
    refute params.key?("code_challenge")
  end
end
