# frozen_string_literal: true

require "test_helper"

class TestRecommendationsResource < Minitest::Test
  include ResourceTestHelper

  OPS = {
    create_asset_group_recommendation: "AssetGroupRecommendation/Create",
    refine_asset_group_recommendation: "AssetGroupRecommendation/Refine",
    create_brand_kit_recommendation: "BrandKitRecommendation/Create",
    create_responsive_ad_recommendation: "ResponsiveAdRecommendation/Create",
    refine_responsive_ad_recommendation: "ResponsiveAdRecommendation/Refine",
    responsive_ad_recommendation_job: "ResponsiveAdRecommendationJob/Query",
    create_responsive_search_ad_recommendation: "ResponsiveSearchAdRecommendation/Create",
    refine_responsive_search_ad_recommendation: "ResponsiveSearchAdRecommendation/Refine"
  }.freeze

  def test_all_recommendation_operations
    OPS.each do |method, path|
      stub = stub_op(:post, "#{CM}/#{path}", { "FinalUrl" => "https://x" })
      sdk_client.campaign_management.recommendations.public_send(method, final_url: "https://x")
      assert_requested stub
    end
  end
end
