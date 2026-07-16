# frozen_string_literal: true

require "test_helper"

class TestSeasonalityAndExclusionsResources < Minitest::Test
  include ResourceTestHelper

  def test_seasonality_create
    stub = stub_op(:post, "#{CM}/SeasonalityAdjustments",
                   { "SeasonalityAdjustments" => [{ "Name" => "S" }] })
    sdk_client.campaign_management.seasonality_adjustments.create(seasonality_adjustments: [{ name: "S" }])
    assert_requested stub
  end

  def test_seasonality_list
    stub = stub_op(:post, "#{CM}/SeasonalityAdjustments/QueryByAccountId", { "AccountId" => 456 })
    sdk_client.campaign_management.seasonality_adjustments.list
    assert_requested stub
  end

  def test_seasonality_find
    stub = stub_op(:post, "#{CM}/SeasonalityAdjustments/QueryByIds",
                   { "SeasonalityAdjustmentIds" => [1] })
    sdk_client.campaign_management.seasonality_adjustments.find(seasonality_adjustment_ids: [1])
    assert_requested stub
  end

  def test_seasonality_update
    stub = stub_op(:put, "#{CM}/SeasonalityAdjustments",
                   { "SeasonalityAdjustments" => [{ "Id" => 1 }] })
    sdk_client.campaign_management.seasonality_adjustments.update(seasonality_adjustments: [{ "Id" => 1 }])
    assert_requested stub
  end

  def test_seasonality_delete
    stub = stub_op(:delete, "#{CM}/SeasonalityAdjustments",
                   { "SeasonalityAdjustmentIds" => [1] })
    sdk_client.campaign_management.seasonality_adjustments.delete(seasonality_adjustment_ids: [1])
    assert_requested stub
  end

  def test_exclusions_create
    stub = stub_op(:post, "#{CM}/DataExclusions", { "DataExclusions" => [{ "Name" => "D" }] })
    sdk_client.campaign_management.data_exclusions.create(data_exclusions: [{ name: "D" }])
    assert_requested stub
  end

  def test_exclusions_list
    stub = stub_op(:post, "#{CM}/DataExclusions/QueryByAccountId", { "AccountId" => 456 })
    sdk_client.campaign_management.data_exclusions.list
    assert_requested stub
  end

  def test_exclusions_find
    stub = stub_op(:post, "#{CM}/DataExclusions/QueryByIds", { "DataExclusionIds" => [2] })
    sdk_client.campaign_management.data_exclusions.find(data_exclusion_ids: [2])
    assert_requested stub
  end

  def test_exclusions_update
    stub = stub_op(:put, "#{CM}/DataExclusions", { "DataExclusions" => [{ "Id" => 2 }] })
    sdk_client.campaign_management.data_exclusions.update(data_exclusions: [{ "Id" => 2 }])
    assert_requested stub
  end

  def test_exclusions_delete
    stub = stub_op(:delete, "#{CM}/DataExclusions", { "DataExclusionIds" => [2] })
    sdk_client.campaign_management.data_exclusions.delete(data_exclusion_ids: [2])
    assert_requested stub
  end
end
