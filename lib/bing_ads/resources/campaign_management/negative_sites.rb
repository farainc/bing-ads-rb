# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Negative site URL operations for campaigns and ad groups
      # (SetNegativeSitesToCampaigns, GetNegativeSitesByCampaignIds,
      # SetNegativeSitesToAdGroups, GetNegativeSitesByAdGroupIds).
      class NegativeSites < Base
        service :campaign_management

        # Sets negative site URLs directly on campaigns, replacing any previously assigned sites
        # (SetNegativeSitesToCampaigns).
        #
        # +campaign_negative_sites+:: Array of CampaignNegativeSites objects identifying campaigns
        #                             and their negative site URLs (maximum 5,000 objects;
        #                             30,000 URLs total across all campaigns).
        # +account_id+:: Identifier of the account that contains the campaigns.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def set_to_campaigns(campaign_negative_sites:, account_id: client.account_id, **options)
          post("/NegativeSites/SetToCampaigns",
               { account_id: account_id, campaign_negative_sites: campaign_negative_sites, **options }.compact)
        end

        # Gets the negative site URLs assigned directly to campaigns
        # (GetNegativeSitesByCampaignIds).
        #
        # +campaign_ids+:: Array of campaign identifiers whose negative sites to retrieve.
        # +account_id+:: Identifier of the account that contains the campaigns.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +campaign_negative_sites+ and +partial_errors+.
        def list_by_campaign_ids(campaign_ids:, account_id: client.account_id, **options)
          post("/NegativeSites/QueryByCampaignIds",
               { account_id: account_id, campaign_ids: campaign_ids, **options }.compact)
        end

        # Sets negative site URLs directly on ad groups, replacing any previously assigned sites
        # (SetNegativeSitesToAdGroups).
        #
        # +ad_group_negative_sites+:: Array of AdGroupNegativeSites objects identifying ad groups
        #                             and their negative site URLs (maximum 5,000 objects;
        #                             30,000 URLs total across all ad groups).
        # +campaign_id+:: Identifier of the campaign that contains the ad groups.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def set_to_ad_groups(ad_group_negative_sites:, campaign_id:, **options)
          post("/NegativeSites/SetToAdGroups",
               { campaign_id: campaign_id, ad_group_negative_sites: ad_group_negative_sites, **options }.compact)
        end

        # Gets the negative site URLs assigned directly to ad groups
        # (GetNegativeSitesByAdGroupIds).
        #
        # +ad_group_ids+:: Array of ad group identifiers whose negative sites to retrieve.
        # +campaign_id+:: Identifier of the campaign that contains the ad groups.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_group_negative_sites+ and +partial_errors+.
        def list_by_ad_group_ids(ad_group_ids:, campaign_id:, **options)
          post("/NegativeSites/QueryByAdGroupIds",
               { campaign_id: campaign_id, ad_group_ids: ad_group_ids, **options }.compact)
        end
      end
    end
  end
end
