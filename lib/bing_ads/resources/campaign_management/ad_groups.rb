# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Ad group CRUD (AddAdGroups, GetAdGroupsByCampaignId, GetAdGroupsByIds,
      # UpdateAdGroups, DeleteAdGroups).
      class AdGroups < Base
        service :campaign_management

        # Adds new ad groups to a campaign (AddAdGroups).
        #
        # +ad_groups+:: Array of AdGroup objects to add (maximum 1,000 per call).
        # +campaign_id+:: Identifier of the campaign to add the ad groups to.
        # +return_inherited_bid_strategy_types+:: Optional. Reserved for future use.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_group_ids+ and +partial_errors+.
        def create(ad_groups:, campaign_id:, return_inherited_bid_strategy_types: nil, **options)
          post("/AdGroups",
               { campaign_id: campaign_id, ad_groups: ad_groups,
                 return_inherited_bid_strategy_types: return_inherited_bid_strategy_types, **options }.compact)
        end

        # Gets all ad groups within a campaign (GetAdGroupsByCampaignId).
        #
        # +campaign_id+:: Identifier of the campaign that contains the ad groups.
        # +return_additional_fields+:: Optional. Additional AdGroup properties to include
        #                              in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +ad_groups+ array.
        def list(campaign_id:, return_additional_fields: nil, **options)
          post("/AdGroups/QueryByCampaignId",
               { campaign_id: campaign_id, return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Gets ad groups by their identifiers (GetAdGroupsByIds).
        #
        # +ad_group_ids+:: Array of ad group identifiers (maximum 1,000 per call).
        # +campaign_id+:: Identifier of the campaign that contains the ad groups.
        # +return_additional_fields+:: Optional. Additional AdGroup properties to include
        #                              in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_groups+ and +partial_errors+.
        def find(ad_group_ids:, campaign_id:, return_additional_fields: nil, **options)
          post("/AdGroups/QueryByIds",
               { campaign_id: campaign_id, ad_group_ids: ad_group_ids,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Updates existing ad groups in a campaign (UpdateAdGroups).
        #
        # +ad_groups+:: Array of AdGroup objects to update (maximum 1,000 per call);
        #               each must include its +id+.
        # +campaign_id+:: Identifier of the campaign that owns the ad groups.
        # +update_audience_ads_bid_adjustment+:: Optional. When +true+, applies each
        #                                        AdGroup's +AudienceAdsBidAdjustment+
        #                                        during the update; defaults to +false+.
        # +return_inherited_bid_strategy_types+:: Optional. Reserved for future use.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(ad_groups:, campaign_id:, update_audience_ads_bid_adjustment: nil,
                   return_inherited_bid_strategy_types: nil, **options)
          put("/AdGroups",
              { campaign_id: campaign_id, ad_groups: ad_groups,
                update_audience_ads_bid_adjustment: update_audience_ads_bid_adjustment,
                return_inherited_bid_strategy_types: return_inherited_bid_strategy_types, **options }.compact)
        end

        # Deletes one or more ad groups from a campaign (DeleteAdGroups).
        #
        # +ad_group_ids+:: Array of identifiers of the ad groups to delete
        #                  (maximum 1,000 per call).
        # +campaign_id+:: Identifier of the campaign that contains the ad groups.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(ad_group_ids:, campaign_id:, **options)
          request(:delete, "/AdGroups",
                  { campaign_id: campaign_id, ad_group_ids: ad_group_ids, **options }.compact)
        end
      end
    end
  end
end
