# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Label CRUD and association helpers
      # (AddLabels, GetLabelsByIds, UpdateLabels, DeleteLabels,
      # SetLabelAssociations, DeleteLabelAssociations,
      # GetLabelAssociationsByEntityIds, GetLabelAssociationsByLabelIds).
      class Labels < Base
        service :campaign_management

        # Adds one or more labels to the account (AddLabels).
        #
        # +labels+:: Array of Label objects to add (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +label_ids+ and +partial_errors+.
        def create(labels:, **options)
          post("/Labels", { labels: labels, **options }.compact)
        end

        # Gets labels by their identifiers (GetLabelsByIds).
        #
        # +label_ids+::  Optional. Array of label identifiers (maximum 1,000). If nil,
        #                all active labels in the account are returned.
        # +page_info+::  Optional. Paging object with +index+ and +size+.
        #                Defaults to page 0 with size 1,000.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +labels+ and +partial_errors+.
        def find(label_ids: nil, page_info: nil, **options)
          post("/Labels/QueryByIds",
               { label_ids: label_ids, page_info: page_info, **options }.compact)
        end

        # Updates one or more existing labels (UpdateLabels).
        #
        # +labels+:: Array of Label objects to update (maximum 100 per call);
        #            each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(labels:, **options)
          put("/Labels", { labels: labels, **options }.compact)
        end

        # Deletes labels by identifier (DeleteLabels).
        #
        # +label_ids+:: Array of label identifiers to delete (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(label_ids:, **options)
          request(:delete, "/Labels", { label_ids: label_ids, **options }.compact)
        end

        # Sets label associations between labels and entities (SetLabelAssociations).
        #
        # +label_associations+:: Array of LabelAssociation objects (maximum 100 per call).
        # +entity_type+::        Entity type to associate, e.g. <tt>"Campaign"</tt>,
        #                        <tt>"AdGroup"</tt>, <tt>"Ad"</tt>, or <tt>"Keyword"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def set_associations(label_associations:, entity_type:, **options)
          post("/LabelAssociations/Set",
               { entity_type: entity_type, label_associations: label_associations, **options }.compact)
        end

        # Deletes label associations (DeleteLabelAssociations).
        #
        # +label_associations+:: Array of LabelAssociation objects to remove.
        # +entity_type+::        Entity type, e.g. <tt>"Campaign"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete_associations(label_associations:, entity_type:, **options)
          request(:delete, "/LabelAssociations",
                  { entity_type: entity_type, label_associations: label_associations, **options }.compact)
        end

        # Gets label associations filtered by entity identifiers
        # (GetLabelAssociationsByEntityIds).
        #
        # +entity_ids+::  Array of entity identifiers (maximum 100 per call).
        # +entity_type+:: Entity type, e.g. <tt>"Campaign"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +label_associations+ and +partial_errors+.
        def associations_by_entity_ids(entity_ids:, entity_type:, **options)
          post("/LabelAssociations/QueryByEntityIds",
               { entity_ids: entity_ids, entity_type: entity_type, **options }.compact)
        end

        # Gets label associations filtered by label identifiers
        # (GetLabelAssociationsByLabelIds).
        #
        # +label_ids+::   Array of label identifiers.
        # +entity_type+:: Entity type, e.g. <tt>"Campaign"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +label_associations+ and +partial_errors+.
        def associations_by_label_ids(label_ids:, entity_type:, **options)
          post("/LabelAssociations/QueryByLabelIds",
               { label_ids: label_ids, entity_type: entity_type, **options }.compact)
        end
      end
    end
  end
end
