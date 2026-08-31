# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Campaign criterion CRUD
      # (AddCampaignCriterions, GetCampaignCriterionsByIds, UpdateCampaignCriterions,
      # DeleteCampaignCriterions).
      class CampaignCriterions < Base
        service :campaign_management

        # Adds one or more campaign criterions (AddCampaignCriterions).
        #
        # +campaign_criterions+:: Array of CampaignCriterion objects to add (maximum 100 per call).
        # +criterion_type+:: The type of criterion to add, e.g. <tt>"Targets"</tt> or
        #                    <tt>"Audience"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +campaign_criterion_ids+ and +nested_partial_errors+.
        def create(campaign_criterions:, criterion_type:, **options)
          post("/CampaignCriterions",
               { campaign_criterions: campaign_criterions, criterion_type: Utils.flags(criterion_type),
                 **options }.compact)
        end

        # Gets campaign criterions by identifiers and type (GetCampaignCriterionsByIds).
        #
        # +campaign_id+:: Identifier of the campaign whose criterions to retrieve.
        # +criterion_type+:: The type of criterion to get; only one type per call (not +Targets+).
        # +campaign_criterion_ids+:: Optional. Array of criterion identifiers to get (maximum 100);
        #                            pass +nil+ to retrieve all criterions for the campaign.
        # +return_additional_fields+:: Optional. Additional criterion properties to include in
        #                              each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +campaign_criterions+ and +partial_errors+.
        def find(campaign_id:, criterion_type:, campaign_criterion_ids: nil,
                 return_additional_fields: nil, **options)
          post("/CampaignCriterions/QueryByIds",
               { campaign_id: campaign_id, campaign_criterion_ids: campaign_criterion_ids,
                 criterion_type: Utils.flags(criterion_type),
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Updates one or more campaign criterions (UpdateCampaignCriterions).
        #
        # +campaign_criterions+:: Array of CampaignCriterion objects to update (maximum 100 per call);
        #                         each must include its +id+ and the +campaign_id+.
        # +criterion_type+:: The type of criterion to update, e.g. <tt>"Targets"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +nested_partial_errors+.
        def update(campaign_criterions:, criterion_type:, **options)
          put("/CampaignCriterions",
              { campaign_criterions: campaign_criterions, criterion_type: Utils.flags(criterion_type),
                **options }.compact)
        end

        # Deletes one or more campaign criterions (DeleteCampaignCriterions).
        #
        # +campaign_criterion_ids+:: Array of criterion identifiers to delete (maximum 100 per call).
        # +campaign_id+:: Identifier of the campaign that owns the criterions.
        # +criterion_type+:: The type of criterion to delete, e.g. <tt>"Targets"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(campaign_criterion_ids:, campaign_id:, criterion_type:, **options)
          request(:delete, "/CampaignCriterions",
                  { campaign_id: campaign_id, campaign_criterion_ids: campaign_criterion_ids,
                    criterion_type: Utils.flags(criterion_type), **options }.compact)
        end
      end
    end
  end
end
