# frozen_string_literal: true

require "test_helper"

class TestCampaignConversionGoalsResource < Minitest::Test
  include ResourceTestHelper

  def goals
    [{ "CampaignId" => 1, "GoalId" => 2 }]
  end

  def test_create
    stub = stub_op(:post, "#{CM}/CampaignConversionGoals",
                   { "AccountId" => 456, "CampaignConversionGoals" => goals })
    sdk_client.campaign_management.campaign_conversion_goals.create(campaign_conversion_goals: goals)
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/CampaignConversionGoals",
                   { "AccountId" => 456, "CampaignConversionGoals" => goals })
    sdk_client.campaign_management.campaign_conversion_goals.delete(campaign_conversion_goals: goals)
    assert_requested stub
  end
end
