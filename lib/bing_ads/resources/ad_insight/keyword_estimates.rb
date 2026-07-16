# frozen_string_literal: true

module BingAds
  module Resources
    module AdInsight
      # Keyword traffic and bid/position estimate operations (GetKeywordTrafficEstimates,
      # GetEstimatedBidByKeywords, GetEstimatedBidByKeywordIds,
      # GetEstimatedPositionByKeywords, GetEstimatedPositionByKeywordIds).
      class KeywordEstimates < Base
        service :ad_insight

        # Returns keyword traffic estimates for a campaign (GetKeywordTrafficEstimates).
        #
        # +campaign_estimators+:: List of campaign estimators, each containing ad
        #                         group and keyword estimators with bid and targeting settings.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +campaign_estimates+.
        def traffic(campaign_estimators:, **options)
          post("/KeywordTrafficEstimates/Query", { campaign_estimators: campaign_estimators, **options }.compact)
        end

        # Returns estimated bid values for keywords (GetEstimatedBidByKeywords).
        #
        # +keywords+:: List of keywords for which to get bid estimates.
        # +target_position_for_ads+:: Optional. Target ad position for the bid estimates.
        #                             Defaults to MainLine1 if not specified.
        # +language+:: Optional. Language of the keywords. Defaults to English if not specified.
        # +location_ids+:: Optional. List of location identifiers to scope the estimates.
        #                  Defaults to United States if not specified.
        # +currency_code+:: Optional. Currency in which to return bid estimates.
        #                   If not set, determined from the account settings.
        # +campaign_id+:: Optional. Campaign identifier to scope the estimates.
        # +ad_group_id+:: Optional. Ad group identifier to scope the estimates.
        # +entity_level_bid+:: Optional. Entity level at which to return the bid estimate.
        #                      Defaults to Keyword if not specified.
        #
        # Returns an object with +keyword_estimates+ and +category+.
        def bid_by_keywords(keywords:, target_position_for_ads: nil, language: nil,
                            location_ids: nil, currency_code: nil, campaign_id: nil,
                            ad_group_id: nil, entity_level_bid: nil, **options)
          post("/EstimatedBid/QueryByKeywords",
               { keywords: keywords, target_position_for_ads: target_position_for_ads,
                 language: language, location_ids: location_ids, currency_code: currency_code,
                 campaign_id: campaign_id, ad_group_id: ad_group_id,
                 entity_level_bid: entity_level_bid, **options }.compact)
        end

        # Returns estimated bid values for keywords by identifier (GetEstimatedBidByKeywordIds).
        #
        # +keyword_ids+:: Optional. List of keyword identifiers for which to get bid estimates.
        # +target_position_for_ads+:: Optional. Target ad position for the bid estimates.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_estimates+.
        def bid_by_keyword_ids(keyword_ids: nil, target_position_for_ads: nil, **options)
          post("/EstimatedBid/QueryByKeywordIds",
               { keyword_ids: keyword_ids, target_position_for_ads: target_position_for_ads, **options }.compact)
        end

        # Returns estimated position for keywords at a given max bid (GetEstimatedPositionByKeywords).
        #
        # +keywords+:: List of keywords for which to get position estimates.
        # +max_bid+:: Maximum bid amount to use for the position estimate.
        # +match_types+:: List of match types to return estimates for.
        # +language+:: Optional. Language of the keywords. Defaults to English if not specified.
        # +location_ids+:: Optional. List of location identifiers to scope the estimates.
        #                  Defaults to United States if not specified.
        # +currency_code+:: Optional. Currency of the max bid value.
        #                   If not set, determined from the account settings.
        # +campaign_id+:: Optional. Campaign identifier to scope the estimates.
        # +ad_group_id+:: Optional. Ad group identifier to scope the estimates.
        #
        # Returns an object with +keyword_estimates+.
        def position_by_keywords(keywords:, max_bid:, match_types:, language: nil, location_ids: nil,
                                 currency_code: nil, campaign_id: nil, ad_group_id: nil, **options)
          post("/EstimatedPosition/QueryByKeywords",
               { keywords: keywords, max_bid: max_bid, language: language,
                 location_ids: location_ids, currency_code: currency_code,
                 match_types: match_types, campaign_id: campaign_id,
                 ad_group_id: ad_group_id, **options }.compact)
        end

        # Returns estimated position for keywords by identifier at a given max bid
        # (GetEstimatedPositionByKeywordIds).
        #
        # +keyword_ids+:: List of keyword identifiers for which to get position estimates.
        # +max_bid+:: Maximum bid amount to use for the position estimate.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_estimates+.
        def position_by_keyword_ids(keyword_ids:, max_bid:, **options)
          post("/EstimatedPosition/QueryByKeywordIds",
               { keyword_ids: keyword_ids, max_bid: max_bid, **options }.compact)
        end
      end
    end
  end
end
