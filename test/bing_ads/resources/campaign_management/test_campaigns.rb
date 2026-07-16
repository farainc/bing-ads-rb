# frozen_string_literal: true

require "test_helper"

class TestCampaignsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/Campaigns",
                   { "AccountId" => 456, "Campaigns" => [{ "Name" => "N" }] })
    sdk_client.campaign_management.campaigns.create(campaigns: [{ name: "N" }])
    assert_requested stub
  end

  def test_list_with_option_passthrough
    stub = stub_op(:post, "#{CM}/Campaigns/QueryByAccountId",
                   { "AccountId" => 456, "CampaignType" => "Search" })
    sdk_client.campaign_management.campaigns.list(campaign_type: "Search")
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/Campaigns/QueryByIds",
                   { "AccountId" => 456, "CampaignIds" => [1, 2] })
    sdk_client.campaign_management.campaigns.find(campaign_ids: [1, 2])
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/Campaigns",
                   { "AccountId" => 456, "Campaigns" => [{ "Id" => 1 }] })
    sdk_client.campaign_management.campaigns.update(campaigns: [{ "Id" => 1 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Campaigns",
                   { "AccountId" => 456, "CampaignIds" => [1] })
    sdk_client.campaign_management.campaigns.delete(campaign_ids: [1])
    assert_requested stub
  end

  def test_account_id_override
    stub = stub_op(:post, "#{CM}/Campaigns/QueryByAccountId", { "AccountId" => 999 })
    sdk_client.campaign_management.campaigns.list(account_id: 999)
    assert_requested stub
  end
end
