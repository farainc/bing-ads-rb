# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Media library management (AddMedia, GetMediaMetaDataByAccountId, GetMediaMetaDataByIds,
      # GetMediaAssociations, DeleteMedia).
      class Media < Base
        service :campaign_management

        # Adds media to an account's asset library (AddMedia).
        #
        # +media+::      Array of Media objects to add (maximum 10 per call).
        # +account_id+:: Identifier of the account that owns the asset library.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +media_ids+.
        def create(media:, account_id: client.account_id, **options)
          post("/Media", { account_id: account_id, media: media, **options }.compact)
        end

        # Deletes media from an account's media library (DeleteMedia).
        #
        # +media_ids+::  Array of media identifiers to delete (maximum 100 per call).
        # +account_id+:: Identifier of the account that owns the media library.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(media_ids:, account_id: client.account_id, **options)
          request(:delete, "/Media", { account_id: account_id, media_ids: media_ids, **options }.compact)
        end

        # Gets media meta data for a given entity type from an account's library (GetMediaMetaDataByAccountId).
        #
        # +media_enabled_entities+::   Space-delimited filter string for the media-enabled entity
        #                              type (e.g. <tt>"ImageAdExtension ResponsiveAd"</tt>).
        # +page_info+::                Optional. Paging object with +index+ and +size+ fields.
        # +return_additional_fields+:: Optional. Additional fields to include in each result.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +media_meta_data+.
        def meta_data_by_account(media_enabled_entities:, page_info: nil, return_additional_fields: nil, **options)
          post("/MediaMetaData/QueryByAccountId",
               { media_enabled_entities: media_enabled_entities, page_info: page_info,
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Gets media meta data by media identifiers (GetMediaMetaDataByIds).
        #
        # +media_ids+::                Array of media identifiers to retrieve (maximum 100 per call).
        # +return_additional_fields+:: Optional. Additional fields to include in each result.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +media_meta_data+ and +partial_errors+.
        def meta_data_by_ids(media_ids:, return_additional_fields: nil, **options)
          post("/MediaMetaData/QueryByIds",
               { media_ids: media_ids, return_additional_fields: Utils.flags(return_additional_fields),
                 **options }.compact)
        end
      end
    end
  end
end
