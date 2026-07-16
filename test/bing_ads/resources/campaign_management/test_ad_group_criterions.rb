# frozen_string_literal: true

require "test_helper"

class TestAdGroupCriterionsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/AdGroupCriterions",
                   { "AdGroupCriterions" => [{ "AdGroupId" => 2 }], "CriterionType" => "Targets" })
    sdk_client.campaign_management.ad_group_criterions.create(
      ad_group_criterions: [{ ad_group_id: 2 }], criterion_type: "Targets"
    )
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/AdGroupCriterions/QueryByIds",
                   { "AdGroupId" => 2, "AdGroupCriterionIds" => [1], "CriterionType" => "Targets" })
    sdk_client.campaign_management.ad_group_criterions.find(
      ad_group_id: 2, ad_group_criterion_ids: [1], criterion_type: "Targets"
    )
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/AdGroupCriterions",
                   { "AdGroupCriterions" => [{ "Id" => 1 }], "CriterionType" => "Targets" })
    sdk_client.campaign_management.ad_group_criterions.update(
      ad_group_criterions: [{ "Id" => 1 }], criterion_type: "Targets"
    )
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/AdGroupCriterions",
                   { "AdGroupId" => 2, "AdGroupCriterionIds" => [1], "CriterionType" => "Targets" })
    sdk_client.campaign_management.ad_group_criterions.delete(
      ad_group_criterion_ids: [1], ad_group_id: 2, criterion_type: "Targets"
    )
    assert_requested stub
  end

  def test_apply_product_partition_actions
    stub = stub_op(:post, "#{CM}/ProductPartitionActions/Apply",
                   { "CriterionActions" => [{ "Action" => "Add" }] })
    sdk_client.campaign_management.ad_group_criterions.apply_product_partition_actions(
      criterion_actions: [{ "Action" => "Add" }]
    )
    assert_requested stub
  end

  def test_apply_hotel_group_actions
    stub = stub_op(:post, "#{CM}/HotelGroupActions/Apply",
                   { "CriterionActions" => [{ "Action" => "Add" }] })
    sdk_client.campaign_management.ad_group_criterions.apply_hotel_group_actions(
      criterion_actions: [{ "Action" => "Add" }]
    )
    assert_requested stub
  end
end
