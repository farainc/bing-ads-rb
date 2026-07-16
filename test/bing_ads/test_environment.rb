# frozen_string_literal: true

require "test_helper"

class TestEnvironment < Minitest::Test
  def test_production_urls
    assert_equal "https://campaign.api.bingads.microsoft.com/CampaignManagement/v13",
                 BingAds::Environment.base_url(:production, :campaign_management)
    assert_equal "https://clientcenter.api.bingads.microsoft.com/CustomerManagement/v13",
                 BingAds::Environment.base_url(:production, :customer_management)
    assert_equal "https://clientcenter.api.bingads.microsoft.com/CustomerBilling/v13",
                 BingAds::Environment.base_url(:production, :customer_billing)
    assert_equal "https://adinsight.api.bingads.microsoft.com/AdInsight/v13",
                 BingAds::Environment.base_url(:production, :ad_insight)
    assert_equal "https://reporting.api.bingads.microsoft.com/Reporting/v13",
                 BingAds::Environment.base_url(:production, :reporting)
    assert_equal "https://bulk.api.bingads.microsoft.com/Bulk/v13",
                 BingAds::Environment.base_url(:production, :bulk)
  end

  def test_sandbox_urls
    assert_equal "https://campaign.api.sandbox.bingads.microsoft.com/CampaignManagement/v13",
                 BingAds::Environment.base_url(:sandbox, :campaign_management)
    assert_equal "https://bulk.api.sandbox.bingads.microsoft.com/Bulk/v13",
                 BingAds::Environment.base_url(:sandbox, :bulk)
  end

  def test_unknown_service_raises
    assert_raises(ArgumentError) { BingAds::Environment.base_url(:production, :nope) }
  end

  def test_unknown_environment_raises
    assert_raises(ArgumentError) { BingAds::Environment.base_url(:staging, :bulk) }
  end
end
