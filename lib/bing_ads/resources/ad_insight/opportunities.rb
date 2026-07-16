# frozen_string_literal: true

module BingAds
  module Resources
    module AdInsight
      # Keyword, bid, and budget opportunity operations (GetKeywordOpportunities,
      # GetBidOpportunities, GetBudgetOpportunities).
      class Opportunities < Base
        service :ad_insight

        # Returns keyword opportunities for an ad group or campaign (GetKeywordOpportunities).
        #
        # +opportunity_type+:: Type of keyword opportunity to return, e.g.
        #                      <tt>"BroadMatch"</tt> or <tt>"CampaignContext"</tt>.
        # +ad_group_id+:: Optional. Ad group identifier to scope keyword opportunities.
        #                 Required if campaign_id is not specified.
        # +campaign_id+:: Optional. Campaign identifier to scope keyword opportunities.
        #                 Required if ad_group_id is not specified.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +opportunities+.
        def keywords(opportunity_type:, ad_group_id: nil, campaign_id: nil, **options)
          post("/KeywordOpportunities/Query",
               { ad_group_id: ad_group_id, campaign_id: campaign_id,
                 opportunity_type: opportunity_type, **options }.compact)
        end

        # Returns bid opportunities for an ad group or campaign (GetBidOpportunities).
        #
        # +opportunity_type+:: Type of bid opportunity to return, e.g.
        #                      <tt>"BidOpportunityTypeAll"</tt>.
        # +ad_group_id+:: Optional. Ad group identifier to scope bid opportunities.
        #                 Required if campaign_id is not specified.
        # +campaign_id+:: Optional. Campaign identifier to scope bid opportunities.
        #                 Required if ad_group_id is not specified.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +opportunities+.
        def bids(opportunity_type:, ad_group_id: nil, campaign_id: nil, **options)
          post("/BidOpportunities/Query",
               { ad_group_id: ad_group_id, campaign_id: campaign_id,
                 opportunity_type: opportunity_type, **options }.compact)
        end

        # Returns budget opportunities for a campaign (GetBudgetOpportunities).
        #
        # +campaign_id+:: Optional. Campaign identifier to scope budget opportunities.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +opportunities+.
        def budgets(campaign_id: nil, **options)
          post("/BudgetOpportunities/Query", { campaign_id: campaign_id, **options }.compact)
        end
      end
    end
  end
end
