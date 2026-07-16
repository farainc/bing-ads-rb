# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Ad group criterion CRUD and partition actions
      # (AddAdGroupCriterions, GetAdGroupCriterionsByIds, UpdateAdGroupCriterions,
      # DeleteAdGroupCriterions, ApplyProductPartitionActions, ApplyHotelGroupActions).
      class AdGroupCriterions < Base
        service :campaign_management

        # Adds one or more ad group criterions (AddAdGroupCriterions).
        #
        # +ad_group_criterions+:: Array of AdGroupCriterion objects to add (maximum 1,000 per call).
        # +criterion_type+:: The type of criterion to add, e.g. <tt>"Webpage"</tt>, <tt>"Targets"</tt>,
        #                    or <tt>"Audience"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_group_criterion_ids+ and +nested_partial_errors+.
        def create(ad_group_criterions:, criterion_type:, **options)
          post("/AdGroupCriterions",
               { ad_group_criterions: ad_group_criterions, criterion_type: criterion_type, **options }.compact)
        end

        # Gets ad group criterions by identifiers and types (GetAdGroupCriterionsByIds).
        #
        # +ad_group_id+:: Identifier of the ad group that owns the criterions.
        # +criterion_type+:: The type of criterion to retrieve; only one type per call.
        # +ad_group_criterion_ids+:: Optional. Array of criterion identifiers to get (maximum 1,000);
        #                            pass +nil+ to retrieve all criterions for the ad group.
        # +return_additional_fields+:: Optional. Additional criterion properties to include in
        #                              each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +ad_group_criterions+ array.
        def find(ad_group_id:, criterion_type:, ad_group_criterion_ids: nil,
                 return_additional_fields: nil, **options)
          post("/AdGroupCriterions/QueryByIds",
               { ad_group_id: ad_group_id, ad_group_criterion_ids: ad_group_criterion_ids,
                 criterion_type: criterion_type,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Updates one or more ad group criterions (UpdateAdGroupCriterions).
        #
        # +ad_group_criterions+:: Array of AdGroupCriterion objects to update (maximum 1,000 per call);
        #                         each must include its +id+ and the +ad_group_id+.
        # +criterion_type+:: The type of criterion to update, e.g. <tt>"Webpage"</tt> or
        #                    <tt>"Targets"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +nested_partial_errors+.
        def update(ad_group_criterions:, criterion_type:, **options)
          put("/AdGroupCriterions",
              { ad_group_criterions: ad_group_criterions, criterion_type: criterion_type, **options }.compact)
        end

        # Deletes one or more ad group criterions (DeleteAdGroupCriterions).
        #
        # +ad_group_criterion_ids+:: Array of criterion identifiers to delete (maximum 1,000 per call).
        # +ad_group_id+:: Identifier of the ad group that contains the criterions.
        # +criterion_type+:: The type of criterion to delete, e.g. <tt>"Targets"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(ad_group_criterion_ids:, ad_group_id:, criterion_type:, **options)
          request(:delete, "/AdGroupCriterions",
                  { ad_group_id: ad_group_id, ad_group_criterion_ids: ad_group_criterion_ids,
                    criterion_type: criterion_type, **options }.compact)
        end

        # Applies add, update, or delete actions to ProductPartition criterions (ApplyProductPartitionActions).
        #
        # +criterion_actions+:: Array of up to 5,000 AdGroupCriterionAction objects, each containing
        #                       an action and a BiddableAdGroupCriterion or NegativeAdGroupCriterion
        #                       with a ProductPartition. All actions must target the same ad group.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_group_criterion_ids+ and +partial_errors+.
        def apply_product_partition_actions(criterion_actions:, **options)
          post("/ProductPartitionActions/Apply",
               { criterion_actions: criterion_actions, **options }.compact)
        end

        # Applies add, update, or delete actions to HotelGroup criterions (ApplyHotelGroupActions).
        #
        # +criterion_actions+:: Array of up to 5,000 AdGroupCriterionAction objects, each containing
        #                       an action and a BiddableAdGroupCriterion with a HotelGroup.
        #                       All actions must target the same ad group.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +ad_group_criterion_ids+ and +partial_errors+.
        def apply_hotel_group_actions(criterion_actions:, **options)
          post("/HotelGroupActions/Apply",
               { criterion_actions: criterion_actions, **options }.compact)
        end
      end
    end
  end
end
