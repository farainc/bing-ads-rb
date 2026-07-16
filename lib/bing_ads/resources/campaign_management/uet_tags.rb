# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Universal Event Tracking tag CRUD
      # (AddUetTags, GetUetTagsByIds, UpdateUetTags).
      class UetTags < Base
        service :campaign_management

        # Adds UET tags for the customer (AddUetTags).
        #
        # +uet_tags+:: Array of UetTag objects to add (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +uet_tags+ and +partial_errors+.
        def create(uet_tags:, **options)
          post("/UetTags", { uet_tags: uet_tags, **options }.compact)
        end

        # Gets UET tags by their identifiers (GetUetTagsByIds).
        #
        # +tag_ids+::               Optional. Array of UET tag identifiers;
        #                           nil or empty returns all tags for the customer.
        # +return_additional_fields+:: Optional. Additional UetTag properties to include
        #                              in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +uet_tags+ and +partial_errors+.
        def find(tag_ids: nil, return_additional_fields: nil, **options)
          post("/UetTags/QueryByIds",
               { tag_ids: tag_ids, return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Updates UET tags (UpdateUetTags).
        #
        # +uet_tags+:: Array of UetTag objects to update (maximum 100 per call);
        #              each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(uet_tags:, **options)
          put("/UetTags", { uet_tags: uet_tags, **options }.compact)
        end

        # Retrieves the JavaScript tracking code for a UET tag.
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object containing the +tag_javascript+ snippet.
        def auth_key(**options)
          post("/UetTagAuthKey/Query", options)
        end
      end
    end
  end
end
