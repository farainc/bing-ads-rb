# frozen_string_literal: true

require "test_helper"

class TestAudienceGroupsResource < Minitest::Test
  include ResourceTestHelper

  def assocs
    [{ "AssetGroupId" => 1, "AudienceGroupId" => 2 }]
  end

  def test_create
    stub = stub_op(:post, "#{CM}/AudienceGroups", { "AudienceGroups" => [{ "Name" => "G" }] })
    sdk_client.campaign_management.audience_groups.create(audience_groups: [{ name: "G" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/AudienceGroups/QueryByIds", { "AudienceGroupIds" => [2] })
    sdk_client.campaign_management.audience_groups.find(audience_group_ids: [2])
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/AudienceGroups", { "AudienceGroups" => [{ "Id" => 2 }] })
    sdk_client.campaign_management.audience_groups.update(audience_groups: [{ "Id" => 2 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/AudienceGroups", { "AudienceGroupIds" => [2] })
    sdk_client.campaign_management.audience_groups.delete(audience_group_ids: [2])
    assert_requested stub
  end

  def test_asset_group_associations_by_asset_group_ids
    stub = stub_op(:post, "#{CM}/AudienceGroupAssetGroupAssociations/QueryByAssetGroupIds",
                   { "AssetGroupIds" => [1] })
    sdk_client.campaign_management.audience_groups.asset_group_associations_by_asset_group_ids(asset_group_ids: [1])
    assert_requested stub
  end

  def test_asset_group_associations_by_audience_group_ids
    stub = stub_op(:post, "#{CM}/AudienceGroupAssetGroupAssociations/QueryByAudienceGroupIds",
                   { "AudienceGroupIds" => [2] })
    sdk_client.campaign_management.audience_groups
              .asset_group_associations_by_audience_group_ids(audience_group_ids: [2])
    assert_requested stub
  end

  def test_set_asset_group_associations
    stub = stub_op(:post, "#{CM}/AudienceGroupAssetGroupAssociations/Set",
                   { "AudienceGroupAssetGroupAssociations" => assocs })
    sdk_client.campaign_management.audience_groups.set_asset_group_associations(
      audience_group_asset_group_associations: assocs
    )
    assert_requested stub
  end

  def test_delete_asset_group_associations
    stub = stub_op(:delete, "#{CM}/AudienceGroupAssetGroupAssociations",
                   { "AudienceGroupAssetGroupAssociations" => assocs })
    sdk_client.campaign_management.audience_groups.delete_asset_group_associations(
      audience_group_asset_group_associations: assocs
    )
    assert_requested stub
  end
end
