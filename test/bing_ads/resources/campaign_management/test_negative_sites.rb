# frozen_string_literal: true

require "test_helper"

class TestNegativeSitesResource < Minitest::Test
  include ResourceTestHelper

  def test_set_to_campaigns
    stub = stub_op(:post, "#{CM}/NegativeSites/SetToCampaigns",
                   { "AccountId" => 456,
                     "CampaignNegativeSites" => [{ "CampaignId" => 1, "NegativeSites" => ["x.com"] }] })
    sdk_client.campaign_management.negative_sites.set_to_campaigns(
      campaign_negative_sites: [{ campaign_id: 1, negative_sites: ["x.com"] }]
    )
    assert_requested stub
  end

  def test_list_by_campaign_ids
    stub = stub_op(:post, "#{CM}/NegativeSites/QueryByCampaignIds",
                   { "AccountId" => 456, "CampaignIds" => [1] })
    sdk_client.campaign_management.negative_sites.list_by_campaign_ids(campaign_ids: [1])
    assert_requested stub
  end

  def test_set_to_ad_groups
    stub = stub_op(:post, "#{CM}/NegativeSites/SetToAdGroups",
                   { "CampaignId" => 9,
                     "AdGroupNegativeSites" => [{ "AdGroupId" => 2, "NegativeSites" => ["y.com"] }] })
    sdk_client.campaign_management.negative_sites.set_to_ad_groups(
      ad_group_negative_sites: [{ ad_group_id: 2, negative_sites: ["y.com"] }], campaign_id: 9
    )
    assert_requested stub
  end

  def test_list_by_ad_group_ids
    stub = stub_op(:post, "#{CM}/NegativeSites/QueryByAdGroupIds",
                   { "CampaignId" => 9, "AdGroupIds" => [2] })
    sdk_client.campaign_management.negative_sites.list_by_ad_group_ids(ad_group_ids: [2], campaign_id: 9)
    assert_requested stub
  end
end
