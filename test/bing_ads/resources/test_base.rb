# frozen_string_literal: true

require "test_helper"

class TestResourceBase < Minitest::Test
  class FakeResource < BingAds::Resources::Base
    service :campaign_management

    def create(body)
      post("/Widgets", body)
    end

    def update(body)
      put("/Widgets", body)
    end

    def destroy(body)
      delete("/Widgets", body)
    end
  end

  URL = "https://campaign.api.bingads.microsoft.com/CampaignManagement/v13/Widgets"

  def client
    oauth = BingAds::OAuth::WebAuthCodeGrant.new(
      client_id: "cid", client_secret: "sec", redirect_uri: "https://x.example.com/cb"
    )
    oauth.tokens = BingAds::OAuth::Tokens.new(access_token: "AT", expires_in: 3600)
    BingAds::Client.new(developer_token: "DT", oauth: oauth,
                        customer_id: 123, account_id: 456)
  end

  def resource
    FakeResource.new(client)
  end

  def test_camelizes_symbol_keys_in_body
    stub = stub_request(:post, URL)
           .with(body: JSON.generate("AccountId" => "456", "Widgets" => [{ "Name" => "W" }]))
           .to_return(status: 200, body: "{}")
    resource.create(account_id: "456", widgets: [{ name: "W" }])
    assert_requested stub
  end

  def test_wraps_response_in_object
    stub_request(:post, URL)
      .to_return(status: 200, body: JSON.generate("WidgetIds" => %w[1 2]))
    result = resource.create({})
    assert_instance_of BingAds::Object, result
    assert_equal %w[1 2], result.widget_ids
  end

  def test_put_and_delete_verbs
    put_stub = stub_request(:put, URL).to_return(status: 200, body: "{}")
    delete_stub = stub_request(:delete, URL).to_return(status: 200, body: "{}")
    resource.update({})
    resource.destroy({})
    assert_requested put_stub
    assert_requested delete_stub
  end

  def test_nil_response_passes_through
    stub_request(:delete, URL).to_return(status: 200, body: "")
    assert_nil resource.destroy({})
  end

  def test_per_call_account_override_reaches_headers
    resource_class = Class.new(BingAds::Resources::Base) do
      service :campaign_management

      def list(account_id: nil)
        post("/Widgets", {}, account_id: account_id)
      end
    end
    stub = stub_request(:post, URL)
           .with(headers: { "CustomerAccountId" => "999" })
           .to_return(status: 200, body: "{}")
    resource_class.new(client).list(account_id: 999)
    assert_requested stub
  end
end
