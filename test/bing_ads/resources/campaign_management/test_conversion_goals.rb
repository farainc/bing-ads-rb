# frozen_string_literal: true

require "test_helper"

class TestConversionGoalsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/ConversionGoals",
                   { "ConversionGoals" => [{ "Type" => "Url", "Name" => "G" }] })
    sdk_client.campaign_management.conversion_goals.create(conversion_goals: [{ type: "Url", name: "G" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/ConversionGoals/QueryByIds",
                   { "ConversionGoalIds" => [5], "ConversionGoalTypes" => "Url" })
    sdk_client.campaign_management.conversion_goals.find(conversion_goal_ids: [5], conversion_goal_types: "Url")
    assert_requested stub
  end

  def test_find_normalizes_flags_goal_types
    stub = stub_op(:post, "#{CM}/ConversionGoals/QueryByIds",
                   { "ConversionGoalTypes" => "Url,Duration,Event" })
    sdk_client.campaign_management.conversion_goals.find(conversion_goal_types: %w[Url Duration Event])
    sdk_client.campaign_management.conversion_goals.find(conversion_goal_types: "Url Duration Event")
    assert_requested stub, times: 2
  end

  def test_find_by_tag_ids
    stub = stub_op(:post, "#{CM}/ConversionGoals/QueryByTagIds",
                   { "TagIds" => [4], "ConversionGoalTypes" => "Url" })
    sdk_client.campaign_management.conversion_goals.find_by_tag_ids(tag_ids: [4], conversion_goal_types: "Url")
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/ConversionGoals", { "ConversionGoals" => [{ "Id" => 5 }] })
    sdk_client.campaign_management.conversion_goals.update(conversion_goals: [{ "Id" => 5 }])
    assert_requested stub
  end
end
