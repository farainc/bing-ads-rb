# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Negative keyword operations scoped to campaigns or ad groups
      # (AddNegativeKeywordsToEntities, GetNegativeKeywordsByEntityIds,
      # DeleteNegativeKeywordsFromEntities).
      class NegativeKeywords < Base
        service :campaign_management

        # Adds negative keywords to the specified campaigns or ad groups
        # (AddNegativeKeywordsToEntities).
        #
        # +entity_negative_keywords+:: Array of EntityNegativeKeyword objects associating negative
        #                              keywords with a campaign or ad group (maximum 1 element,
        #                              each containing up to 20,000 negative keywords).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +negative_keyword_ids+ and +nested_partial_errors+.
        def add_to_entities(entity_negative_keywords:, **options)
          post("/EntityNegativeKeywords",
               { entity_negative_keywords: entity_negative_keywords, **options }.compact)
        end

        # Gets the negative keywords assigned directly to campaigns or ad groups
        # (GetNegativeKeywordsByEntityIds).
        #
        # +entity_ids+:: Array of entity identifiers to query (maximum 1 element).
        # +entity_type+:: The type of entity, e.g. <tt>"Campaign"</tt> or <tt>"AdGroup"</tt>.
        # +parent_entity_id+:: For +AdGroup+ entity type, the campaign identifier containing all
        #                      specified ad groups. Ignored when +entity_type+ is +Campaign+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +entity_negative_keywords+ and +partial_errors+.
        def list_by_entity_ids(entity_ids:, entity_type:, parent_entity_id: nil, **options)
          post("/NegativeKeywords/QueryByEntityIds",
               { entity_ids: entity_ids, entity_type: entity_type,
                 parent_entity_id: parent_entity_id, **options }.compact)
        end

        # Deletes negative keywords from the specified campaigns or ad groups
        # (DeleteNegativeKeywordsFromEntities).
        #
        # +entity_negative_keywords+:: Array of EntityNegativeKeyword objects identifying the
        #                              negative keywords to delete (maximum 1 element, each
        #                              containing up to 20,000 negative keywords).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +nested_partial_errors+.
        def delete_from_entities(entity_negative_keywords:, **options)
          request(:delete, "/EntityNegativeKeywords",
                  { entity_negative_keywords: entity_negative_keywords, **options }.compact)
        end
      end
    end
  end
end
