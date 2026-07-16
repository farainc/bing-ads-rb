# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Shared entity and shared list management (negative keyword lists, etc.).
      class SharedEntities < Base
        service :campaign_management

        # Adds a shared entity and optionally seeds it with list items (AddSharedEntity).
        #
        # +shared_entity+:: The shared entity to add (e.g. a NegativeKeywordList object).
        # +list_items+::    Optional. Array of list items to add to the shared entity upon creation.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with the new +shared_entity_id+ and +list_item_ids+.
        def create(shared_entity:, list_items: nil, **options)
          post("/SharedEntity", { shared_entity: shared_entity, list_items: list_items, **options }.compact)
        end

        # Retrieves shared entities that belong to the account (GetSharedEntitiesByAccountId).
        #
        # +shared_entity_type+:: The type of shared entity to retrieve (e.g. "NegativeKeywordList").
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +shared_entities+ array.
        def list(shared_entity_type:, **options)
          post("/SharedEntities/QueryByAccountId", { shared_entity_type: shared_entity_type, **options }.compact)
        end

        # Updates shared entities (UpdateSharedEntities).
        #
        # +shared_entities+:: Array of shared entity objects with updated field values.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(shared_entities:, **options)
          put("/SharedEntities", { shared_entities: shared_entities, **options }.compact)
        end

        # Deletes shared entities (DeleteSharedEntities).
        #
        # +shared_entities+:: Array of shared entity objects to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(shared_entities:, **options)
          request(:delete, "/SharedEntities", { shared_entities: shared_entities, **options }.compact)
        end

        # Adds list items to an existing shared list (AddListItemsToSharedList).
        #
        # +list_items+::   Array of list item objects to add (e.g. NegativeKeyword objects).
        # +shared_entity+:: The shared list entity to add the items to.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +list_item_ids+ and +partial_errors+.
        def add_list_items(list_items:, shared_entity:, **options)
          post("/ListItems", { list_items: list_items, shared_entity: shared_entity, **options }.compact)
        end

        # Retrieves list items from a shared list (GetListItemsBySharedList).
        #
        # +shared_entity+:: The shared list entity whose items to retrieve.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +list_items+ array.
        def list_items(shared_entity:, **options)
          post("/ListItems/QueryBySharedList", { shared_entity: shared_entity, **options }.compact)
        end

        # Deletes list items from a shared list (DeleteListItemsFromSharedList).
        #
        # +list_item_ids+:: Array of identifiers for the list items to delete.
        # +shared_entity+:: The shared list entity that contains the items.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete_list_items(list_item_ids:, shared_entity:, **options)
          request(:delete, "/ListItems",
                  { list_item_ids: list_item_ids, shared_entity: shared_entity, **options }.compact)
        end

        # Associates shared entities with campaigns or other entities (SetSharedEntityAssociations).
        #
        # +associations+:: Array of SharedEntityAssociation objects defining the links to set.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def set_associations(associations:, **options)
          post("/SharedEntityAssociations/Set", { associations: associations, **options }.compact)
        end

        # Retrieves shared entity associations by entity identifiers (GetSharedEntityAssociationsByEntityIds).
        #
        # +entity_ids+::         Array of entity identifiers to look up associations for.
        # +entity_type+::        The type of entity (e.g. "Campaign").
        # +shared_entity_type+:: The type of shared entity (e.g. "NegativeKeywordList").
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +associations+ array.
        def associations_by_entity_ids(entity_ids:, entity_type:, shared_entity_type:, **options)
          post("/SharedEntityAssociations/QueryByEntityIds",
               { entity_ids: entity_ids, entity_type: entity_type,
                 shared_entity_type: shared_entity_type, **options }.compact)
        end

        # Retrieves shared entity associations by shared entity identifiers
        # (GetSharedEntityAssociationsBySharedEntityIds).
        #
        # +shared_entity_ids+:: Array of shared entity identifiers to look up associations for.
        # +entity_type+::       The type of entity (e.g. "Campaign").
        # +shared_entity_type+:: The type of shared entity (e.g. "NegativeKeywordList").
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +associations+ array.
        def associations_by_shared_entity_ids(shared_entity_ids:, entity_type:, shared_entity_type:, **options)
          post("/SharedEntityAssociations/QueryBySharedEntityIds",
               { shared_entity_ids: shared_entity_ids, entity_type: entity_type,
                 shared_entity_type: shared_entity_type, **options }.compact)
        end

        # Deletes associations between shared entities and other entities (DeleteSharedEntityAssociations).
        #
        # +associations+:: Array of SharedEntityAssociation objects identifying the links to remove.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete_associations(associations:, **options)
          request(:delete, "/SharedEntityAssociations", { associations: associations, **options }.compact)
        end
      end
    end
  end
end
