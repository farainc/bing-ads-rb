# frozen_string_literal: true

require "test_helper"

class TestOfflineConversionsResource < Minitest::Test
  include ResourceTestHelper

  def test_apply
    stub = stub_op(:post, "#{CM}/OfflineConversions/Apply",
                   { "OfflineConversions" => [{ "ConversionName" => "C" }] })
    sdk_client.campaign_management.offline_conversions.apply(offline_conversions: [{ conversion_name: "C" }])
    assert_requested stub
  end

  def test_apply_adjustments
    stub = stub_op(:post, "#{CM}/OfflineConversionAdjustments/Apply",
                   { "OfflineConversionAdjustments" => [{ "AdjustmentType" => "Retract" }] })
    sdk_client.campaign_management.offline_conversions.apply_adjustments(
      offline_conversion_adjustments: [{ adjustment_type: "Retract" }]
    )
    assert_requested stub
  end

  def test_apply_online_adjustments
    stub = stub_op(:post, "#{CM}/OnlineConversionAdjustments/Apply",
                   { "OnlineConversionAdjustments" => [{ "AdjustmentType" => "Restate" }] })
    sdk_client.campaign_management.offline_conversions.apply_online_adjustments(
      online_conversion_adjustments: [{ adjustment_type: "Restate" }]
    )
    assert_requested stub
  end

  def test_reports
    stub = stub_op(:post, "#{CM}/OfflineConversionReports/Query", { "PageInfo" => { "Index" => 0 } })
    sdk_client.campaign_management.offline_conversions.reports(page_info: { index: 0 })
    assert_requested stub
  end

  def test_report_by_goal_ids
    stub = stub_op(:post, "#{CM}/OfflineConversionReport/QueryByGoalIds", { "GoalIds" => [5] })
    sdk_client.campaign_management.offline_conversions.report_by_goal_ids(goal_ids: [5])
    assert_requested stub
  end
end
