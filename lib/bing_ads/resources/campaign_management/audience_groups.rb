# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Audience group CRUD and asset-group association helpers
      # (AddAudienceGroups, GetAudienceGroupsByIds, UpdateAudienceGroups,
      # DeleteAudienceGroups, SetAudienceGroupAssetGroupAssociations,
      # GetAudienceGroupAssetGroupAssociationsByAssetGroupIds,
      # GetAudienceGroupAssetGroupAssociationsByAudienceGroupIds,
      # DeleteAudienceGroupAssetGroupAssociations).
      class AudienceGroups < Base
        service :campaign_management

        # Adds one or more audience groups (AddAudienceGroups).
        #
        # +audience_groups+:: Array of AudienceGroup objects to add.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +audience_group_ids+ and +partial_errors+.
        def create(audience_groups:, **options)
          post("/AudienceGroups", { audience_groups: audience_groups, **options }.compact)
        end

        # Gets audience groups by their identifiers (GetAudienceGroupsByIds).
        #
        # +audience_group_ids+:: Array of audience group identifiers to retrieve.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +audience_groups+ and +partial_errors+.
        def find(audience_group_ids:, **options)
          post("/AudienceGroups/QueryByIds", { audience_group_ids: audience_group_ids, **options }.compact)
        end

        # Updates one or more existing audience groups (UpdateAudienceGroups).
        #
        # +audience_groups+:: Array of AudienceGroup objects to update; each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(audience_groups:, **options)
          put("/AudienceGroups", { audience_groups: audience_groups, **options }.compact)
        end

        # Deletes audience groups by identifier (DeleteAudienceGroups).
        #
        # +audience_group_ids+:: Array of audience group identifiers to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(audience_group_ids:, **options)
          request(:delete, "/AudienceGroups", { audience_group_ids: audience_group_ids, **options }.compact)
        end

        # Gets audience-group/asset-group associations filtered by asset group
        # (GetAudienceGroupAssetGroupAssociationsByAssetGroupIds).
        #
        # +asset_group_ids+:: Array of asset group identifiers to filter by.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +audience_group_asset_group_associations+ and +partial_errors+.
        def asset_group_associations_by_asset_group_ids(asset_group_ids:, **options)
          post("/AudienceGroupAssetGroupAssociations/QueryByAssetGroupIds",
               { asset_group_ids: asset_group_ids, **options }.compact)
        end

        # Gets audience-group/asset-group associations filtered by audience group
        # (GetAudienceGroupAssetGroupAssociationsByAudienceGroupIds).
        #
        # +audience_group_ids+:: Array of audience group identifiers to filter by.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +audience_group_asset_group_associations+ and +partial_errors+.
        def asset_group_associations_by_audience_group_ids(audience_group_ids:, **options)
          post("/AudienceGroupAssetGroupAssociations/QueryByAudienceGroupIds",
               { audience_group_ids: audience_group_ids, **options }.compact)
        end

        # Sets audience-group/asset-group associations (SetAudienceGroupAssetGroupAssociations).
        #
        # +audience_group_asset_group_associations+:: Array of AudienceGroupAssetGroupAssociation
        #                                             objects to set.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def set_asset_group_associations(audience_group_asset_group_associations:, **options)
          post("/AudienceGroupAssetGroupAssociations/Set",
               { audience_group_asset_group_associations: audience_group_asset_group_associations, **options }.compact)
        end

        # Deletes audience-group/asset-group associations (DeleteAudienceGroupAssetGroupAssociations).
        #
        # +audience_group_asset_group_associations+:: Array of AudienceGroupAssetGroupAssociation
        #                                             objects to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete_asset_group_associations(audience_group_asset_group_associations:, **options)
          request(:delete, "/AudienceGroupAssetGroupAssociations",
                  { audience_group_asset_group_associations: audience_group_asset_group_associations,
                    **options }.compact)
        end
      end
    end
  end
end
