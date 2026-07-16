# frozen_string_literal: true

require "test_helper"

class TestCampaignCriterionsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/CampaignCriterions",
                   { "CampaignCriterions" => [{ "CampaignId" => 9 }], "CriterionType" => "Targets" })
    sdk_client.campaign_management.campaign_criterions.create(
      campaign_criterions: [{ campaign_id: 9 }], criterion_type: "Targets"
    )
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/CampaignCriterions/QueryByIds",
                   { "CampaignId" => 9, "CriterionType" => "Targets" })
    sdk_client.campaign_management.campaign_criterions.find(campaign_id: 9, criterion_type: "Targets")
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/CampaignCriterions",
                   { "CampaignCriterions" => [{ "Id" => 1 }], "CriterionType" => "Targets" })
    sdk_client.campaign_management.campaign_criterions.update(
      campaign_criterions: [{ "Id" => 1 }], criterion_type: "Targets"
    )
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/CampaignCriterions",
                   { "CampaignId" => 9, "CampaignCriterionIds" => [1], "CriterionType" => "Targets" })
    sdk_client.campaign_management.campaign_criterions.delete(
      campaign_criterion_ids: [1], campaign_id: 9, criterion_type: "Targets"
    )
    assert_requested stub
  end
end
