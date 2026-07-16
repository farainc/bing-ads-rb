# frozen_string_literal: true

require "test_helper"

class TestAdsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/Ads",
                   { "AdGroupId" => 2, "Ads" => [{ "Type" => "ResponsiveSearchAd" }] })
    sdk_client.campaign_management.ads.create(ads: [{ type: "ResponsiveSearchAd" }], ad_group_id: 2)
    assert_requested stub
  end

  def test_list
    stub = stub_op(:post, "#{CM}/Ads/QueryByAdGroupId",
                   { "AdGroupId" => 2, "AdTypes" => ["ResponsiveSearchAd"] })
    sdk_client.campaign_management.ads.list(ad_group_id: 2, ad_types: ["ResponsiveSearchAd"])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/Ads/QueryByIds", { "AdGroupId" => 2, "AdIds" => [7] })
    sdk_client.campaign_management.ads.find(ad_ids: [7], ad_group_id: 2)
    assert_requested stub
  end

  def test_list_by_editorial_status
    stub = stub_op(:post, "#{CM}/Ads/QueryByEditorialStatus",
                   { "AdGroupId" => 2, "EditorialStatus" => "Disapproved" })
    sdk_client.campaign_management.ads.list_by_editorial_status(editorial_status: "Disapproved", ad_group_id: 2)
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/Ads", { "AdGroupId" => 2, "Ads" => [{ "Id" => 7 }] })
    sdk_client.campaign_management.ads.update(ads: [{ "Id" => 7 }], ad_group_id: 2)
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Ads", { "AdGroupId" => 2, "AdIds" => [7] })
    sdk_client.campaign_management.ads.delete(ad_ids: [7], ad_group_id: 2)
    assert_requested stub
  end
end
