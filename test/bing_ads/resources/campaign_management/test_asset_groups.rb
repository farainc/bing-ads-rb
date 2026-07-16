# frozen_string_literal: true

require "test_helper"

class TestAssetGroupsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/AssetGroups",
                   { "CampaignId" => 9, "AssetGroups" => [{ "Name" => "A" }] })
    sdk_client.campaign_management.asset_groups.create(asset_groups: [{ name: "A" }], campaign_id: 9)
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/AssetGroups/QueryByIds", { "CampaignId" => 9, "AssetGroupIds" => [3] })
    sdk_client.campaign_management.asset_groups.find(asset_group_ids: [3], campaign_id: 9)
    assert_requested stub
  end

  def test_list_by_campaign
    stub = stub_op(:post, "#{CM}/AssetGroups/QueryByCampaignId", { "CampaignId" => 9 })
    sdk_client.campaign_management.asset_groups.list_by_campaign(campaign_id: 9)
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/AssetGroups",
                   { "CampaignId" => 9, "AssetGroups" => [{ "Id" => 3 }] })
    sdk_client.campaign_management.asset_groups.update(asset_groups: [{ "Id" => 3 }], campaign_id: 9)
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/AssetGroups",
                   { "CampaignId" => 9, "AssetGroupIds" => [3] })
    sdk_client.campaign_management.asset_groups.delete(asset_group_ids: [3], campaign_id: 9)
    assert_requested stub
  end

  def test_editorial_reasons
    stub = stub_op(:post, "#{CM}/AssetGroupsEditorialReasons/Query", { "AssetGroupIds" => [3] })
    sdk_client.campaign_management.asset_groups.editorial_reasons(asset_group_ids: [3])
    assert_requested stub
  end

  def test_listing_groups_by_ids
    stub = stub_op(:post, "#{CM}/AssetGroupListingGroups/QueryByIds",
                   { "AssetGroupId" => 3, "ListingGroupIds" => [4] })
    sdk_client.campaign_management.asset_groups.listing_groups_by_ids(asset_group_id: 3, listing_group_ids: [4])
    assert_requested stub
  end

  def test_apply_listing_group_actions
    stub = stub_op(:post, "#{CM}/AssetGroupListingGroupActions/Apply",
                   { "ListingGroupActions" => [{ "Action" => "Add" }] })
    sdk_client.campaign_management.asset_groups.apply_listing_group_actions(
      listing_group_actions: [{ "Action" => "Add" }]
    )
    assert_requested stub
  end
end
