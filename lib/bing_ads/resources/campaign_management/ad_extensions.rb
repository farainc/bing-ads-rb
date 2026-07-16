# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Ad extension CRUD and association management (AddAdExtensions, GetAdExtensionsByIds,
      # UpdateAdExtensions, DeleteAdExtensions, GetAdExtensionIdsByAccountId,
      # GetAdExtensionsAssociations, SetAdExtensionsAssociations, DeleteAdExtensionsAssociations,
      # GetAdExtensionsEditorialReasons).
      class AdExtensions < Base
        service :campaign_management

        # Adds one or more ad extensions to the account's library (AddAdExtensions).
        #
        # +ad_extensions+:: Array of AdExtension objects to add (maximum 100 per call).
        # +account_id+::    Identifier of the account that will own the extensions.
        #                   Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_extension_identities+ and +nested_partial_errors+.
        def create(ad_extensions:, account_id: client.account_id, **options)
          post("/AdExtensions", { account_id: account_id, ad_extensions: ad_extensions, **options }.compact)
        end

        # Gets ad extensions by their identifiers (GetAdExtensionsByIds).
        #
        # +ad_extension_ids+::         Array of ad extension identifiers to retrieve (maximum 100).
        # +account_id+::               Identifier of the account that owns the extensions.
        #                              Defaults to the client's +account_id+.
        # +ad_extension_type+::        Optional. Space-delimited AdExtensionsTypeFilter string (e.g.
        #                              <tt>"SitelinkAdExtension CallAdExtension"</tt>).
        # +return_additional_fields+:: Optional. Reserved for future use.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_extensions+ and +partial_errors+.
        def find(ad_extension_ids:, account_id: client.account_id,
                 ad_extension_type: nil, return_additional_fields: nil, **options)
          post("/AdExtensions/QueryByIds",
               { account_id: account_id, ad_extension_ids: ad_extension_ids,
                 ad_extension_type: ad_extension_type,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Updates one or more ad extensions within the account's library (UpdateAdExtensions).
        #
        # +ad_extensions+:: Array of AdExtension objects to update (maximum 100 per call).
        # +account_id+::    Identifier of the account that contains the extensions.
        #                   Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +nested_partial_errors+.
        def update(ad_extensions:, account_id: client.account_id, **options)
          put("/AdExtensions", { account_id: account_id, ad_extensions: ad_extensions, **options }.compact)
        end

        # Deletes one or more ad extensions from the account's library (DeleteAdExtensions).
        #
        # +ad_extension_ids+:: Array of ad extension identifiers to delete (maximum 100).
        # +account_id+::       Identifier of the account that owns the extensions.
        #                      Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(ad_extension_ids:, account_id: client.account_id, **options)
          request(:delete, "/AdExtensions",
                  { account_id: account_id, ad_extension_ids: ad_extension_ids, **options }.compact)
        end

        # Gets ad extension IDs from the account's library (GetAdExtensionIdsByAccountId).
        #
        # +ad_extension_type+:: Space-delimited AdExtensionsTypeFilter string specifying which
        #                       extension types to retrieve (e.g. <tt>"SitelinkAdExtension"</tt>).
        # +account_id+::        Identifier of the account that contains the extensions.
        #                       Defaults to the client's +account_id+.
        # +association_type+::  Optional. Filters by entity association type (e.g. <tt>"Campaign"</tt>).
        #                       Pass +nil+ to include extensions not associated with any entity.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_extension_ids+.
        def ids_by_account(ad_extension_type:, account_id: client.account_id,
                           association_type: nil, **options)
          post("/AdExtensionIds/QueryByAccountId",
               { account_id: account_id, ad_extension_type: ad_extension_type,
                 association_type: association_type, **options }.compact)
        end

        # Gets ad extension associations by entity identifiers (GetAdExtensionsAssociations).
        #
        # +association_type+::         Filters returned associations by entity type
        #                              (e.g. <tt>"Campaign"</tt>).
        # +account_id+::               Identifier of the account that owns the extensions.
        #                              Defaults to the client's +account_id+.
        # +entity_ids+::               Optional. Array of entity identifiers (maximum 100) to filter by.
        # +ad_extension_type+::        Optional. Space-delimited AdExtensionsTypeFilter string.
        # +return_additional_fields+:: Optional. Reserved for future use.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_extension_association_collection+ and +partial_errors+.
        def associations(association_type:, account_id: client.account_id,
                         entity_ids: nil, ad_extension_type: nil, return_additional_fields: nil, **options)
          post("/AdExtensionsAssociations/Query",
               { account_id: account_id, association_type: association_type,
                 entity_ids: entity_ids, ad_extension_type: ad_extension_type,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Associates ad extensions with campaigns or ad groups (SetAdExtensionsAssociations).
        #
        # +ad_extension_id_to_entity_id_associations+:: Array of AdExtensionIdToEntityIdAssociation
        #                                               objects (maximum 100 per call).
        # +association_type+::                          Entity type for all associations in the list
        #                                               (e.g. <tt>"Campaign"</tt>).
        # +account_id+::                                Identifier of the account that owns the extensions.
        #                                               Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def set_associations(ad_extension_id_to_entity_id_associations:, association_type:,
                             account_id: client.account_id, **options)
          post("/AdExtensionsAssociations/Set",
               { account_id: account_id,
                 ad_extension_id_to_entity_id_associations: ad_extension_id_to_entity_id_associations,
                 association_type: association_type, **options }.compact)
        end

        # Removes ad extension associations from campaigns or ad groups (DeleteAdExtensionsAssociations).
        #
        # +ad_extension_id_to_entity_id_associations+:: Array of AdExtensionIdToEntityIdAssociation
        #                                               objects to remove (maximum 100 per call).
        # +association_type+::                          Entity type for all associations in the list
        #                                               (e.g. <tt>"Campaign"</tt>).
        # +account_id+::                                Identifier of the account that owns the extensions.
        #                                               Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete_associations(ad_extension_id_to_entity_id_associations:, association_type:,
                                account_id: client.account_id, **options)
          request(:delete, "/AdExtensionsAssociations",
                  { account_id: account_id,
                    ad_extension_id_to_entity_id_associations: ad_extension_id_to_entity_id_associations,
                    association_type: association_type, **options }.compact)
        end

        # Gets editorial failure reasons for ad extension associations (GetAdExtensionsEditorialReasons).
        #
        # +ad_extension_id_to_entity_id_associations+:: Array of AdExtensionIdToEntityIdAssociation
        #                                               objects to query.
        # +association_type+::                          Filters returned associations by entity type.
        # +account_id+::                                Identifier of the account that owns the extensions.
        #                                               Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +editorial_reasons+ and +partial_errors+.
        def editorial_reasons(ad_extension_id_to_entity_id_associations:, association_type:,
                              account_id: client.account_id, **options)
          post("/AdExtensionsEditorialReasons/Query",
               { account_id: account_id,
                 ad_extension_id_to_entity_id_associations: ad_extension_id_to_entity_id_associations,
                 association_type: association_type, **options }.compact)
        end
      end
    end
  end
end
