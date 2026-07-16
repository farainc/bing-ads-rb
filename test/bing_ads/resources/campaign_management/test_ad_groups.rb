# frozen_string_literal: true

require "test_helper"

class TestAdGroupsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/AdGroups",
                   { "CampaignId" => 9, "AdGroups" => [{ "Name" => "G" }] })
    sdk_client.campaign_management.ad_groups.create(ad_groups: [{ name: "G" }], campaign_id: 9)
    assert_requested stub
  end

  def test_list
    stub = stub_op(:post, "#{CM}/AdGroups/QueryByCampaignId",
                   { "CampaignId" => 9, "ReturnAdditionalFields" => "AdScheduleUseSearcherTimeZone" })
    sdk_client.campaign_management.ad_groups.list(campaign_id: 9,
                                                  return_additional_fields: "AdScheduleUseSearcherTimeZone")
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/AdGroups/QueryByIds",
                   { "CampaignId" => 9, "AdGroupIds" => [2, 3] })
    sdk_client.campaign_management.ad_groups.find(ad_group_ids: [2, 3], campaign_id: 9)
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/AdGroups",
                   { "CampaignId" => 9, "AdGroups" => [{ "Id" => 2 }] })
    sdk_client.campaign_management.ad_groups.update(ad_groups: [{ "Id" => 2 }], campaign_id: 9)
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/AdGroups",
                   { "CampaignId" => 9, "AdGroupIds" => [2] })
    sdk_client.campaign_management.ad_groups.delete(ad_group_ids: [2], campaign_id: 9)
    assert_requested stub
  end
end
