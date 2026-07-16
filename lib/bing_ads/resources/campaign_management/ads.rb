# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Ad CRUD within an ad group (AddAds, GetAdsByAdGroupId, GetAdsByIds,
      # GetAdsByEditorialStatus, UpdateAds, DeleteAds).
      class Ads < Base
        service :campaign_management

        # Adds one or more ads to an ad group (AddAds).
        #
        # +ads+::          Array of Ad objects to add (maximum 50 per call).
        # +ad_group_id+::  Identifier of the ad group to add the ads to.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_ids+ and +partial_errors+.
        def create(ads:, ad_group_id:, **options)
          post("/Ads", { ad_group_id: ad_group_id, ads: ads, **options }.compact)
        end

        # Retrieves the ads within an ad group (GetAdsByAdGroupId).
        #
        # +ad_group_id+::              Identifier of the ad group to retrieve ads from.
        # +ad_types+::                 Optional. One or more ad types to retrieve (AdType array).
        # +return_additional_fields+:: Optional. Additional Ad properties to include in each
        #                              returned object (AdAdditionalField).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +ads+ array.
        def list(ad_group_id:, ad_types: nil, return_additional_fields: nil, **options)
          post("/Ads/QueryByAdGroupId",
               { ad_group_id: ad_group_id, ad_types: ad_types,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Retrieves specific ads from an ad group by their identifiers (GetAdsByIds).
        #
        # +ad_ids+::                   Array of ad identifiers to retrieve (maximum 20 per call).
        # +ad_group_id+::              Identifier of the ad group that contains the ads.
        # +ad_types+::                 Optional. One or more ad types to return (AdType array).
        # +return_additional_fields+:: Optional. Additional Ad properties to include in each
        #                              returned object (AdAdditionalField).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ads+ and +partial_errors+.
        def find(ad_ids:, ad_group_id:, ad_types: nil, return_additional_fields: nil, **options)
          post("/Ads/QueryByIds",
               { ad_group_id: ad_group_id, ad_ids: ad_ids, ad_types: ad_types,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Retrieves ads by editorial review status within an ad group (GetAdsByEditorialStatus).
        #
        # +editorial_status+::         The editorial review status ads must have (AdEditorialStatus).
        # +ad_group_id+::              Identifier of the ad group to retrieve ads from.
        # +ad_types+::                 Optional. One or more ad types to return (AdType array).
        # +return_additional_fields+:: Optional. Additional Ad properties to include in each
        #                              returned object (AdAdditionalField).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +ads+ array.
        def list_by_editorial_status(editorial_status:, ad_group_id:, ad_types: nil,
                                     return_additional_fields: nil, **options)
          post("/Ads/QueryByEditorialStatus",
               { ad_group_id: ad_group_id, editorial_status: editorial_status, ad_types: ad_types,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Updates one or more ads within an ad group (UpdateAds).
        #
        # +ads+::          Array of Ad objects to update (maximum 50 per call);
        #                  each must include its +id+.
        # +ad_group_id+::  Identifier of the ad group that contains the ads.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(ads:, ad_group_id:, **options)
          put("/Ads", { ad_group_id: ad_group_id, ads: ads, **options }.compact)
        end

        # Deletes one or more ads from an ad group (DeleteAds).
        #
        # +ad_ids+::       Array of identifiers of the ads to delete (maximum 50 per call).
        # +ad_group_id+::  Identifier of the ad group that contains the ads.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(ad_ids:, ad_group_id:, **options)
          request(:delete, "/Ads", { ad_group_id: ad_group_id, ad_ids: ad_ids, **options }.compact)
        end
      end
    end
  end
end
