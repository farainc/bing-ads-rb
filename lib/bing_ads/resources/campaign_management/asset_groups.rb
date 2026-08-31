# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Asset group CRUD, editorial-reasons, listing-group, and listing-group-action helpers
      # (AddAssetGroups, GetAssetGroupsByCampaignId, GetAssetGroupsByIds,
      # UpdateAssetGroups, DeleteAssetGroups, GetAssetGroupsEditorialReasons,
      # GetAssetGroupListingGroupsByIds, ApplyAssetGroupListingGroupActions).
      class AssetGroups < Base
        service :campaign_management

        # Adds asset groups to a Performance Max campaign (AddAssetGroups).
        #
        # +asset_groups+:: Array of AssetGroup objects to add (maximum 100 per call).
        # +campaign_id+::  Identifier of the Performance Max campaign.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +asset_group_ids+ and +partial_errors+.
        def create(asset_groups:, campaign_id:, **options)
          post("/AssetGroups", { campaign_id: campaign_id, asset_groups: asset_groups, **options }.compact)
        end

        # Gets asset groups by their identifiers (GetAssetGroupsByIds).
        #
        # +asset_group_ids+::          Array of asset group identifiers (maximum 100 per call).
        # +campaign_id+::              Identifier of the Performance Max campaign.
        # +return_additional_fields+:: Optional. Additional AssetGroup properties to include.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +asset_groups+ and +partial_errors+.
        def find(asset_group_ids:, campaign_id:, return_additional_fields: nil, **options)
          post("/AssetGroups/QueryByIds",
               { campaign_id: campaign_id, asset_group_ids: asset_group_ids,
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Gets all asset groups in a Performance Max campaign (GetAssetGroupsByCampaignId).
        #
        # +campaign_id+:: Identifier of the Performance Max campaign.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +asset_groups+.
        def list_by_campaign(campaign_id:, **options)
          post("/AssetGroups/QueryByCampaignId", { campaign_id: campaign_id, **options }.compact)
        end

        # Updates asset groups in a Performance Max campaign (UpdateAssetGroups).
        #
        # +asset_groups+:: Array of AssetGroup objects to update (maximum 100 per call);
        #                  each must include its +id+.
        # +campaign_id+::  Identifier of the Performance Max campaign.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(asset_groups:, campaign_id:, **options)
          put("/AssetGroups", { campaign_id: campaign_id, asset_groups: asset_groups, **options }.compact)
        end

        # Deletes asset groups from a Performance Max campaign (DeleteAssetGroups).
        #
        # +asset_group_ids+:: Array of asset group identifiers to delete (maximum 100 per call).
        # +campaign_id+::     Identifier of the Performance Max campaign.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(asset_group_ids:, campaign_id:, **options)
          request(:delete, "/AssetGroups",
                  { campaign_id: campaign_id, asset_group_ids: asset_group_ids, **options }.compact)
        end

        # Gets editorial reasons for asset groups (GetAssetGroupsEditorialReasons).
        #
        # +asset_group_ids+:: Optional. Array of asset group identifiers.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +editorial_reasons+.
        def editorial_reasons(asset_group_ids: nil, **options)
          post("/AssetGroupsEditorialReasons/Query",
               { asset_group_ids: asset_group_ids, **options }.compact)
        end

        # Gets asset group listing groups by their identifiers (GetAssetGroupListingGroupsByIds).
        #
        # +asset_group_id+::    Identifier of the asset group.
        # +listing_group_ids+:: Optional. Array of listing group identifiers.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +asset_group_listing_groups+ and +partial_errors+.
        def listing_groups_by_ids(asset_group_id: nil, listing_group_ids: nil, **options)
          post("/AssetGroupListingGroups/QueryByIds",
               { asset_group_id: asset_group_id, listing_group_ids: listing_group_ids, **options }.compact)
        end

        # Applies listing group actions to an asset group (ApplyAssetGroupListingGroupActions).
        #
        # +listing_group_actions+:: Array of AssetGroupListingGroupAction objects to apply.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +asset_group_listing_group_ids+ and +partial_errors+.
        def apply_listing_group_actions(listing_group_actions: nil, **options)
          post("/AssetGroupListingGroupActions/Apply",
               { listing_group_actions: listing_group_actions, **options }.compact)
        end
      end
    end
  end
end
