# frozen_string_literal: true

require "test_helper"

class TestAdInsightResources < Minitest::Test
  include ResourceTestHelper

  AI = "https://adinsight.api.bingads.microsoft.com/AdInsight/v13"

  def test_keyword_ideas
    stub_op(:post, "#{AI}/KeywordIdeas/Query")
    sdk_client.ad_insight.keyword_ideas.ideas(
      expand_ideas: false, idea_attributes: [], search_parameters: []
    )
    assert_requested :post, "#{AI}/KeywordIdeas/Query"

    stub_op(:post, "#{AI}/KeywordIdeaCategories/Query")
    sdk_client.ad_insight.keyword_ideas.idea_categories
    assert_requested :post, "#{AI}/KeywordIdeaCategories/Query"

    stub_op(:post, "#{AI}/KeywordCategories/Query")
    sdk_client.ad_insight.keyword_ideas.categories(
      keywords: [], language: "en", publisher_country: "US", max_categories: 5
    )
    assert_requested :post, "#{AI}/KeywordCategories/Query"

    stub_op(:post, "#{AI}/KeywordDemographics/Query")
    sdk_client.ad_insight.keyword_ideas.demographics(
      keywords: [], language: "en", publisher_country: "US", device: []
    )
    assert_requested :post, "#{AI}/KeywordDemographics/Query"

    stub_op(:post, "#{AI}/KeywordLocations/Query")
    sdk_client.ad_insight.keyword_ideas.locations(
      keywords: [], language: "en", publisher_country: "US", device: [],
      level: "Country", parent_country: "US", max_locations: 10
    )
    assert_requested :post, "#{AI}/KeywordLocations/Query"

    stub_op(:post, "#{AI}/KeywordSuggestions/QueryByUrl")
    sdk_client.ad_insight.keyword_ideas.suggest_for_url(url: "https://example.com")
    assert_requested :post, "#{AI}/KeywordSuggestions/QueryByUrl"

    stub_op(:post, "#{AI}/KeywordSuggestions/QueryByKeywords")
    sdk_client.ad_insight.keyword_ideas.suggest_from_existing(keywords: [])
    assert_requested :post, "#{AI}/KeywordSuggestions/QueryByKeywords"
  end

  def test_keyword_ideas_body_serialization
    stub = stub_op(:post, "#{AI}/KeywordIdeas/Query",
                   { "ExpandIdeas" => true, "IdeaAttributes" => ["Keyword"], "SearchParameters" => [] })
    sdk_client.ad_insight.keyword_ideas.ideas(expand_ideas: true, idea_attributes: ["Keyword"],
                                              search_parameters: [])
    assert_requested stub
  end

  def test_keyword_estimates
    stub_op(:post, "#{AI}/KeywordTrafficEstimates/Query")
    sdk_client.ad_insight.keyword_estimates.traffic(campaign_estimators: [])
    assert_requested :post, "#{AI}/KeywordTrafficEstimates/Query"

    stub_op(:post, "#{AI}/EstimatedBid/QueryByKeywords")
    sdk_client.ad_insight.keyword_estimates.bid_by_keywords(keywords: [])
    assert_requested :post, "#{AI}/EstimatedBid/QueryByKeywords"

    stub_op(:post, "#{AI}/EstimatedBid/QueryByKeywordIds")
    sdk_client.ad_insight.keyword_estimates.bid_by_keyword_ids
    assert_requested :post, "#{AI}/EstimatedBid/QueryByKeywordIds"

    stub_op(:post, "#{AI}/EstimatedPosition/QueryByKeywords")
    sdk_client.ad_insight.keyword_estimates.position_by_keywords(
      keywords: [], max_bid: 1.0, match_types: []
    )
    assert_requested :post, "#{AI}/EstimatedPosition/QueryByKeywords"

    stub_op(:post, "#{AI}/EstimatedPosition/QueryByKeywordIds")
    sdk_client.ad_insight.keyword_estimates.position_by_keyword_ids(keyword_ids: [], max_bid: 1.0)
    assert_requested :post, "#{AI}/EstimatedPosition/QueryByKeywordIds"
  end

  def test_bid_landscapes
    stub_op(:post, "#{AI}/BidLandscape/QueryByKeywordIds")
    sdk_client.ad_insight.bid_landscapes.list_by_keyword_ids(keyword_ids: [])
    assert_requested :post, "#{AI}/BidLandscape/QueryByKeywordIds"

    stub_op(:post, "#{AI}/BidLandscape/QueryByAdGroupIds")
    sdk_client.ad_insight.bid_landscapes.list_by_ad_group_ids(ad_group_bid_landscape_inputs: [])
    assert_requested :post, "#{AI}/BidLandscape/QueryByAdGroupIds"

    stub_op(:post, "#{AI}/BidLandscape/QueryByCampaignIds")
    sdk_client.ad_insight.bid_landscapes.list_by_campaign_ids
    assert_requested :post, "#{AI}/BidLandscape/QueryByCampaignIds"
  end

  def test_opportunities
    stub_op(:post, "#{AI}/KeywordOpportunities/Query")
    sdk_client.ad_insight.opportunities.keywords(opportunity_type: "BroadMatch")
    assert_requested :post, "#{AI}/KeywordOpportunities/Query"

    stub_op(:post, "#{AI}/BidOpportunities/Query")
    sdk_client.ad_insight.opportunities.bids(opportunity_type: "BidOpportunityTypeAll")
    assert_requested :post, "#{AI}/BidOpportunities/Query"

    stub_op(:post, "#{AI}/BudgetOpportunities/Query")
    sdk_client.ad_insight.opportunities.budgets
    assert_requested :post, "#{AI}/BudgetOpportunities/Query"
  end

  def test_historical
    stub_op(:post, "#{AI}/HistoricalKeywordPerformance/Query")
    sdk_client.ad_insight.historical.keyword_performance(
      keywords: [], language: "en", match_types: []
    )
    assert_requested :post, "#{AI}/HistoricalKeywordPerformance/Query"

    stub_op(:post, "#{AI}/HistoricalSearchCount/Query")
    sdk_client.ad_insight.historical.search_count(
      keywords: [], language: "en", start_date: "2026-01-01", end_date: "2026-01-31",
      time_period_rollup: "Monthly"
    )
    assert_requested :post, "#{AI}/HistoricalSearchCount/Query"
  end

  def test_recommendations
    stub_op(:post, "#{AI}/Recommendations/Query")
    sdk_client.ad_insight.recommendations.list(recommendation_type: "ResponsiveSearchAd")
    assert_requested :post, "#{AI}/Recommendations/Query"

    stub_op(:post, "#{AI}/Recommendations/Retrieve")
    sdk_client.ad_insight.recommendations.retrieve(recommendation_types: [])
    assert_requested :post, "#{AI}/Recommendations/Retrieve"

    stub_op(:post, "#{AI}/Recommendations/Apply")
    sdk_client.ad_insight.recommendations.apply(entities: [])
    assert_requested :post, "#{AI}/Recommendations/Apply"

    stub_op(:post, "#{AI}/Recommendations/Dismiss")
    sdk_client.ad_insight.recommendations.dismiss(entities: [])
    assert_requested :post, "#{AI}/Recommendations/Dismiss"

    stub_op(:post, "#{AI}/Recommendations/Tag")
    sdk_client.ad_insight.recommendations.tag(
      recommendation_type: "ResponsiveSearchAd", recommendations_info: [], lable: "test"
    )
    assert_requested :post, "#{AI}/Recommendations/Tag"

    stub_op(:post, "#{AI}/AutoApplyOptInStatus/Query")
    sdk_client.ad_insight.recommendations.auto_apply_opt_in_status(recommendation_types_inputs: [])
    assert_requested :post, "#{AI}/AutoApplyOptInStatus/Query"

    stub_op(:post, "#{AI}/AutoApplyOptInStatus/Set")
    sdk_client.ad_insight.recommendations.set_auto_apply_opt_in_status(
      auto_apply_opt_in_status_inputs: []
    )
    assert_requested :post, "#{AI}/AutoApplyOptInStatus/Set"
  end

  def test_insights
    stub_op(:post, "#{AI}/AuctionInsightData/Query")
    sdk_client.ad_insight.insights.auction_insight(entity_type: "Campaign", search_parameters: [])
    assert_requested :post, "#{AI}/AuctionInsightData/Query"

    stub_op(:post, "#{AI}/AudienceBreakdown/Query")
    sdk_client.ad_insight.insights.audience_breakdown
    assert_requested :post, "#{AI}/AudienceBreakdown/Query"

    stub_op(:post, "#{AI}/AudienceFullEstimation/Query")
    sdk_client.ad_insight.insights.audience_full_estimation
    assert_requested :post, "#{AI}/AudienceFullEstimation/Query"

    stub_op(:post, "#{AI}/PerformanceInsightsDetailData/QueryByAccountId")
    sdk_client.ad_insight.insights.performance_insights_detail(
      entity_type: "Campaign", start_date: "2026-01-01", end_date: "2026-01-31"
    )
    assert_requested :post, "#{AI}/PerformanceInsightsDetailData/QueryByAccountId"

    stub_op(:post, "#{AI}/TextAssetSuggestions/QueryByFinalUrls")
    sdk_client.ad_insight.insights.text_asset_suggestions(final_urls: [])
    assert_requested :post, "#{AI}/TextAssetSuggestions/QueryByFinalUrls"

    stub_op(:post, "#{AI}/DomainCategories/Query")
    sdk_client.ad_insight.insights.domain_categories(domain_name: "example.com", language: "en")
    assert_requested :post, "#{AI}/DomainCategories/Query"
  end
end
