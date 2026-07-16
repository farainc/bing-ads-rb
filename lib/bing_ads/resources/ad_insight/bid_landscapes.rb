# frozen_string_literal: true

module BingAds
  module Resources
    module AdInsight
      # Bid landscape operations (GetBidLandscapeByKeywordIds, GetBidLandscapeByAdGroupIds).
      class BidLandscapes < Base
        service :ad_insight

        # Returns bid landscape data for keywords by identifier (GetBidLandscapeByKeywordIds).
        #
        # +keyword_ids+:: List of keyword identifiers for which to get bid landscapes.
        # +include_current_bid+:: Optional. Whether to include the current bid in the landscape
        #                         data. Defaults to false.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_bid_landscapes+.
        def list_by_keyword_ids(keyword_ids:, include_current_bid: nil, **options)
          post("/BidLandscape/QueryByKeywordIds",
               { keyword_ids: keyword_ids, include_current_bid: include_current_bid, **options }.compact)
        end

        # Returns bid landscape data for ad groups by identifier (GetBidLandscapeByAdGroupIds).
        #
        # +ad_group_bid_landscape_inputs+:: List of ad group bid landscape input objects
        #                                   specifying the ad group identifiers and landscape type.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_group_bid_landscapes+.
        def list_by_ad_group_ids(ad_group_bid_landscape_inputs:, **options)
          post("/BidLandscape/QueryByAdGroupIds",
               { ad_group_bid_landscape_inputs: ad_group_bid_landscape_inputs, **options }.compact)
        end

        # Returns bid landscape data for campaigns by identifier.
        #
        # NOTE: No matching Microsoft Advertising API operation was found for this path.
        #       Request body fields are unverifiable; no explicit fields are listed.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns bid landscape data for the specified campaigns.
        def list_by_campaign_ids(**options)
          post("/BidLandscape/QueryByCampaignIds", { **options }.compact)
        end
      end
    end
  end
end
