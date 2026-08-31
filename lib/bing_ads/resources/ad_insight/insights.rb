# frozen_string_literal: true

module BingAds
  module Resources
    module AdInsight
      # Auction insight, audience, performance insight, text asset suggestion, and domain
      # category operations (GetAuctionInsightData, GetAudienceFullEstimation,
      # GetPerformanceInsightsDetailDataByAccountId, GetTextAssetSuggestionsByFinalUrls,
      # GetDomainCategories).
      class Insights < Base
        service :ad_insight

        # Returns auction insight data for the specified entities (GetAuctionInsightData).
        #
        # +entity_type+:: Type of entity for the auction insight query, e.g.
        #                 <tt>"Campaign"</tt> or <tt>"AdGroup"</tt>.
        # +search_parameters+:: List of search parameters to filter the results.
        # +entity_ids+:: Optional. List of entity identifiers for the auction insight query.
        #                Required for non-account entity types; optional for the account entity type.
        # +return_additional_fields+:: Optional. Additional fields to include in the response.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +auction_insight_results+.
        def auction_insight(entity_type:, search_parameters:, entity_ids: nil,
                            return_additional_fields: nil, **options)
          post("/AuctionInsightData/Query",
               { entity_type: entity_type, entity_ids: entity_ids,
                 search_parameters: search_parameters,
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Returns audience breakdown data.
        #
        # NOTE: No matching Microsoft Advertising API operation was found for this path.
        #       Request body fields are unverifiable; no explicit fields are listed.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns audience breakdown data.
        def audience_breakdown(**options)
          post("/AudienceBreakdown/Query", { **options }.compact)
        end

        # Returns full audience estimation data (GetAudienceFullEstimation).
        #
        # NOTE: The Microsoft Advertising API documentation for this operation was too large
        #       to fully verify. Request body fields are omitted as unverifiable.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns audience full estimation data.
        def audience_full_estimation(**options)
          post("/AudienceFullEstimation/Query", { **options }.compact)
        end

        # Returns performance insights detail data for an account
        # (GetPerformanceInsightsDetailDataByAccountId).
        #
        # +entity_type+:: Type of entity for the performance insights query.
        # +start_date+:: Start date of the date range for the query.
        # +end_date+:: End date of the date range for the query.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +performance_insights_detail_data+.
        def performance_insights_detail(entity_type:, start_date:, end_date:, **options)
          post("/PerformanceInsightsDetailData/QueryByAccountId",
               { entity_type: entity_type, start_date: start_date, end_date: end_date, **options }.compact)
        end

        # Returns text asset suggestions for a list of final URLs
        # (GetTextAssetSuggestionsByFinalUrls).
        #
        # +final_urls+:: List of final URLs for which to generate text asset suggestions.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +text_asset_suggestions+.
        def text_asset_suggestions(final_urls:, **options)
          post("/TextAssetSuggestions/QueryByFinalUrls", { final_urls: final_urls, **options }.compact)
        end

        # Returns domain category data for a domain (GetDomainCategories).
        #
        # +domain_name+:: Domain name for which to retrieve categories.
        # +language+:: Language of the categories to return.
        # +category_name+:: Optional. Name of the category to filter results.
        #                   If not included, all categories are returned.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +categories+.
        def domain_categories(domain_name:, language:, category_name: nil, **options)
          post("/DomainCategories/Query",
               { category_name: category_name, domain_name: domain_name,
                 language: language, **options }.compact)
        end
      end
    end
  end
end
