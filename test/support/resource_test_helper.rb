# frozen_string_literal: true

# Shared helpers for resource-class tests: a ready-to-use client and the
# Campaign Management base URL.
module ResourceTestHelper
  CM = "https://campaign.api.bingads.microsoft.com/CampaignManagement/v13"

  def sdk_client
    @sdk_client ||= begin
      oauth = BingAds::OAuth::WebAuthCodeGrant.new(
        client_id: "cid", client_secret: "sec", redirect_uri: "https://x.example.com/cb"
      )
      oauth.tokens = BingAds::OAuth::Tokens.new(access_token: "AT", expires_in: 3600)
      BingAds::Client.new(developer_token: "DT", oauth: oauth, customer_id: 123, account_id: 456)
    end
  end

  # Stubs verb+url expecting the exact JSON body (given as a Ruby hash with
  # already-camelized keys) and returns 200 {}.
  def stub_op(verb, url, body = nil)
    stub = stub_request(verb, url)
    stub = stub.with(body: JSON.generate(body)) if body
    stub.to_return(status: 200, body: "{}")
  end
end
