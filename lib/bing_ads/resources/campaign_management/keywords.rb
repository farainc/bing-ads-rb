# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Keyword CRUD (AddKeywords, GetKeywordsByAdGroupId, GetKeywordsByIds,
      # GetKeywordsByEditorialStatus, UpdateKeywords, DeleteKeywords).
      class Keywords < Base
        service :campaign_management

        # Adds one or more keywords to an ad group (AddKeywords).
        #
        # +keywords+:: Array of Keyword objects to add (maximum 1,000 per call).
        # +ad_group_id+:: Identifier of the ad group to add the keywords to.
        # +return_inherited_bid_strategy_types+:: Optional. Set true to include the inherited
        #                                         bid strategy type in the response.
        # +asset_group_id+:: Optional. Identifier of the asset group to add the keywords to.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_ids+, +inherited_bid_strategy_types+, and +partial_errors+.
        def create(keywords:, ad_group_id:, return_inherited_bid_strategy_types: nil, asset_group_id: nil, **options)
          post("/Keywords",
               { ad_group_id: ad_group_id, keywords: keywords,
                 return_inherited_bid_strategy_types: return_inherited_bid_strategy_types,
                 asset_group_id: asset_group_id, **options }.compact)
        end

        # Gets all keywords within an ad group (GetKeywordsByAdGroupId).
        #
        # +ad_group_id+:: Identifier of the ad group whose keywords are returned.
        # +return_additional_fields+:: Optional. Additional Keyword properties to include
        #                              in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +keywords+ array.
        def list(ad_group_id:, return_additional_fields: nil, **options)
          post("/Keywords/QueryByAdGroupId",
               { ad_group_id: ad_group_id, return_additional_fields: Utils.flags(return_additional_fields),
                 **options }.compact)
        end

        # Gets keywords by their identifiers (GetKeywordsByIds).
        #
        # +keyword_ids+:: Array of keyword identifiers to retrieve (maximum 1,000 per call).
        # +ad_group_id+:: Identifier of the ad group whose keywords you want to get.
        # +return_additional_fields+:: Optional. Additional Keyword properties to include
        #                              in each returned object.
        # +asset_group_id+:: Optional. Identifier of the asset group whose keywords you want to get.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keywords+ and +partial_errors+.
        def find(keyword_ids:, ad_group_id:, return_additional_fields: nil, asset_group_id: nil, **options)
          post("/Keywords/QueryByIds",
               { ad_group_id: ad_group_id, keyword_ids: keyword_ids,
                 return_additional_fields: Utils.flags(return_additional_fields),
                 asset_group_id: asset_group_id, **options }.compact)
        end

        # Gets keywords with a specified editorial review status (GetKeywordsByEditorialStatus).
        #
        # +editorial_status+:: The review status of the keywords to retrieve (e.g. <tt>"ActiveAndPending"</tt>).
        # +ad_group_id+:: Identifier of the ad group that contains the keywords.
        # +return_additional_fields+:: Optional. Additional Keyword properties to include
        #                              in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +keywords+ array.
        def list_by_editorial_status(editorial_status:, ad_group_id:, return_additional_fields: nil, **options)
          post("/Keywords/QueryByEditorialStatus",
               { ad_group_id: ad_group_id, editorial_status: editorial_status,
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Updates keywords within an ad group (UpdateKeywords).
        #
        # +keywords+:: Array of Keyword objects to update (maximum 1,000 per call);
        #              each must include its +id+.
        # +ad_group_id+:: Identifier of the ad group whose keywords will be updated.
        # +return_inherited_bid_strategy_types+:: Optional. Set true to include the inherited
        #                                         bid strategy type in the response.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +inherited_bid_strategy_types+ and +partial_errors+.
        def update(keywords:, ad_group_id:, return_inherited_bid_strategy_types: nil, **options)
          put("/Keywords",
              { ad_group_id: ad_group_id, keywords: keywords,
                return_inherited_bid_strategy_types: return_inherited_bid_strategy_types, **options }.compact)
        end

        # Deletes one or more keywords in an ad group (DeleteKeywords).
        #
        # +keyword_ids+:: Array of identifiers of the keywords to delete (maximum 1,000 per call).
        # +ad_group_id+:: Identifier of the ad group that contains the keywords to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(keyword_ids:, ad_group_id:, **options)
          request(:delete, "/Keywords",
                  { ad_group_id: ad_group_id, keyword_ids: keyword_ids, **options }.compact)
        end
      end
    end
  end
end
