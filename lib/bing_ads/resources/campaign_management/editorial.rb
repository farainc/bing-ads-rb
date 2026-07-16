# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Editorial review operations for ads and keywords (GetEditorialReasonsByIds,
      # AppealEditorialRejections).
      class Editorial < Base
        service :campaign_management

        # Gets editorial failure reasons for ads or keywords by their identifiers
        # (GetEditorialReasonsByIds).
        #
        # +entity_id_to_parent_id_associations+:: Array of EntityIdToParentIdAssociation objects
        #                                         (maximum 1,000), each pairing an ad or keyword
        #                                         identifier with its parent ad group identifier.
        # +entity_type+::                         Type of entities in the list; supported values
        #                                         are <tt>"Ad"</tt> and <tt>"Keyword"</tt>.
        # +account_id+::                          Identifier of the account that contains the entities.
        #                                         Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +editorial_reasons+ and +partial_errors+.
        def reasons_by_ids(entity_id_to_parent_id_associations:, entity_type:,
                           account_id: client.account_id, **options)
          post("/EditorialReasons/QueryByIds",
               { account_id: account_id,
                 entity_id_to_parent_id_associations: entity_id_to_parent_id_associations,
                 entity_type: entity_type, **options }.compact)
        end

        # Submits an editorial appeal for ads or keywords that failed review
        # (AppealEditorialRejections).
        #
        # +entity_id_to_parent_id_associations+:: Array of EntityIdToParentIdAssociation objects
        #                                         (maximum 1,000) identifying the ads or keywords
        #                                         to appeal; must be all ads or all keywords.
        # +entity_type+::                         Type of entities in the list (e.g. <tt>"Ad"</tt>,
        #                                         <tt>"Keyword"</tt>).
        # +justification_text+::                  Justification for the appeal (maximum 1,000
        #                                         characters); applies to all specified entities.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def appeal(entity_id_to_parent_id_associations:, entity_type:, justification_text:, **options)
          post("/EditorialRejections/Appeal",
               { entity_id_to_parent_id_associations: entity_id_to_parent_id_associations,
                 entity_type: entity_type, justification_text: justification_text, **options }.compact)
        end
      end
    end
  end
end
