# frozen_string_literal: true

require "test_helper"

class TestClient < Minitest::Test
  CM_URL = "https://campaign.api.bingads.microsoft.com/CampaignManagement/v13/Campaigns/QueryByIds"
  CUSTOMER_URL = "https://clientcenter.api.bingads.microsoft.com/CustomerManagement/v13/User/Query"
  TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

  def oauth(access_token: "AT")
    auth = BingAds::OAuth::WebAuthCodeGrant.new(
      client_id: "cid", client_secret: "sec", redirect_uri: "https://app.example.com/cb"
    )
    auth.tokens = BingAds::OAuth::Tokens.new(
      access_token: access_token, refresh_token: "RT", expires_in: 3600
    )
    auth
  end

  def client(oauth: self.oauth, **)
    BingAds::Client.new(
      developer_token: "DT", oauth: oauth, customer_id: 123, account_id: 456,
      sleeper: ->(_s) {}, **
    )
  end

  def test_execute_sends_all_four_headers
    stub = stub_request(:post, CM_URL)
           .with(headers: {
                   "Authorization" => "Bearer AT",
                   "DeveloperToken" => "DT",
                   "CustomerId" => "123",
                   "CustomerAccountId" => "456"
                 })
           .to_return(status: 200, body: "{}")
    client.execute(service: :campaign_management, method: :post,
                   path: "/Campaigns/QueryByIds", body: {})
    assert_requested stub
  end

  def test_customer_management_receives_all_four_headers
    stub = stub_request(:post, CUSTOMER_URL)
           .with(headers: {
                   "Authorization" => "Bearer AT",
                   "DeveloperToken" => "DT",
                   "CustomerId" => "123",
                   "CustomerAccountId" => "456"
                 })
           .to_return(status: 200, body: "{}")
    client.execute(service: :customer_management, method: :post, path: "/User/Query", body: {})
    assert_requested stub
  end

  def test_per_call_account_id_override
    stub = stub_request(:post, CM_URL)
           .with(headers: { "CustomerAccountId" => "999" })
           .to_return(status: 200, body: "{}")
    client.execute(service: :campaign_management, method: :post,
                   path: "/Campaigns/QueryByIds", body: {}, account_id: 999)
    assert_requested stub
  end

  def test_google_identity_provider_header
    google = BingAds::OAuth::GoogleWebAuthCodeGrant.new(
      client_id: "cid", client_secret: "sec", redirect_uri: "https://app.example.com/cb"
    )
    google.tokens = BingAds::OAuth::Tokens.new(access_token: "AT", expires_in: 3600)
    stub = stub_request(:post, CM_URL)
           .with(headers: { "IdentityProvider" => "Google" })
           .to_return(status: 200, body: "{}")
    client(oauth: google).execute(service: :campaign_management, method: :post,
                                  path: "/Campaigns/QueryByIds", body: {})
    assert_requested stub
  end

  def test_sandbox_environment_uses_sandbox_url
    sandbox_url = "https://campaign.api.sandbox.bingads.microsoft.com/CampaignManagement/v13/Campaigns/QueryByIds"
    stub = stub_request(:post, sandbox_url).to_return(status: 200, body: "{}")
    client(env: :sandbox).execute(service: :campaign_management, method: :post,
                                  path: "/Campaigns/QueryByIds", body: {})
    assert_requested stub
  end

  def test_401_refreshes_and_retries_once
    stub_request(:post, TOKEN_URL)
      .with(body: hash_including("grant_type" => "refresh_token"))
      .to_return(status: 200, body: JSON.generate(
        "access_token" => "NEW", "refresh_token" => "RT2", "expires_in" => 3600
      ))
    stub_request(:post, CM_URL)
      .with(headers: { "Authorization" => "Bearer AT" })
      .to_return(status: 401, body: JSON.generate(
        "OperationErrors" => [{ "Code" => 109, "Message" => "expired" }]
      ))
    retried = stub_request(:post, CM_URL)
              .with(headers: { "Authorization" => "Bearer NEW" })
              .to_return(status: 200, body: JSON.generate("Ok" => true))

    result = client.execute(service: :campaign_management, method: :post,
                            path: "/Campaigns/QueryByIds", body: {})
    assert_equal({ "Ok" => true }, result)
    assert_requested retried
  end

  def test_persistent_401_raises_after_one_refresh
    stub_request(:post, TOKEN_URL)
      .to_return(status: 200, body: JSON.generate("access_token" => "NEW", "expires_in" => 3600))
    stub_request(:post, CM_URL).to_return(status: 401, body: "{}")
    assert_raises(BingAds::AuthenticationError) do
      client.execute(service: :campaign_management, method: :post,
                     path: "/Campaigns/QueryByIds", body: {})
    end
    assert_requested :post, TOKEN_URL, times: 1
  end

  def test_shutdown_delegates_to_connection
    fake = Minitest::Mock.new
    fake.expect(:shutdown, nil)
    c = client(connection: fake)
    c.shutdown
    fake.verify
  end

  def test_service_accessors_are_memoized_across_threads
    c = client
    instances = Array.new(16) { Thread.new { c.campaign_management } }.map(&:value)
    assert_equal 1, instances.map(&:object_id).uniq.size
    assert_same c.bulk, c.bulk
  end

  def test_non_auth_errors_do_not_trigger_refresh
    stub_request(:post, CM_URL).to_return(status: 400, body: "{}")
    assert_raises(BingAds::HTTPError) do
      client.execute(service: :campaign_management, method: :post,
                     path: "/Campaigns/QueryByIds", body: {})
    end
    assert_not_requested :post, TOKEN_URL
  end
end
