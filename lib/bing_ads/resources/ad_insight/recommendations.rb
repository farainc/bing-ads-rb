# frozen_string_literal: true

module BingAds
  module Resources
    module AdInsight
      # Recommendation operations (GetRecommendations, RetrieveRecommendations,
      # ApplyRecommendations, DismissRecommendations, TagRecommendations,
      # GetAutoApplyOptInStatus, SetAutoApplyOptInStatus).
      class Recommendations < Base
        service :ad_insight

        # Returns recommendations for a campaign or ad group (GetRecommendations).
        #
        # +recommendation_type+:: Type of recommendations to return.
        # +campaign_id+:: Optional. Campaign identifier to scope the recommendations.
        #                 Required if ad_group_id is not specified.
        # +ad_group_id+:: Optional. Ad group identifier to scope the recommendations.
        #                 Required if campaign_id is not specified.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +recommendations+.
        def list(recommendation_type:, campaign_id: nil, ad_group_id: nil, **options)
          post("/Recommendations/Query",
               { campaign_id: campaign_id, ad_group_id: ad_group_id,
                 recommendation_type: recommendation_type, **options }.compact)
        end

        # Retrieves a batch of recommendations (RetrieveRecommendations).
        #
        # +recommendation_types+:: List of recommendation types to retrieve.
        # +max_count+:: Optional. Maximum number of recommendations to return.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +recommendations+.
        def retrieve(recommendation_types:, max_count: nil, **options)
          post("/Recommendations/Retrieve",
               { recommendation_types: recommendation_types, max_count: max_count, **options }.compact)
        end

        # Applies a list of recommendations (ApplyRecommendations).
        #
        # +entities+:: List of recommendation entities to apply.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +apply_recommendation_results+.
        def apply(entities:, **options)
          post("/Recommendations/Apply", { entities: entities, **options }.compact)
        end

        # Dismisses a list of recommendations (DismissRecommendations).
        #
        # +entities+:: List of recommendation entities to dismiss.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +dismiss_recommendation_results+.
        def dismiss(entities:, **options)
          post("/Recommendations/Dismiss", { entities: entities, **options }.compact)
        end

        # Tags recommendations with a label (TagRecommendations).
        #
        # +recommendation_type+:: Type of recommendations to tag.
        # +recommendations_info+:: List of recommendation info objects identifying
        #                          the recommendations to tag.
        # +lable+:: Label to apply to the recommendations. Note: this uses the
        #           API's documented spelling "Lable" (not "Label").
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +tag_recommendation_results+.
        def tag(recommendation_type:, recommendations_info:, lable:, **options)
          post("/Recommendations/Tag",
               { recommendation_type: recommendation_type,
                 recommendations_info: recommendations_info, lable: lable, **options }.compact)
        end

        # Returns the auto-apply opt-in status for recommendation types
        # (GetAutoApplyOptInStatus).
        #
        # +recommendation_types_inputs+:: List of recommendation types for which to
        #                                 get the auto-apply opt-in status.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +auto_apply_opt_in_status+.
        def auto_apply_opt_in_status(recommendation_types_inputs:, **options)
          post("/AutoApplyOptInStatus/Query",
               { recommendation_types_inputs: recommendation_types_inputs, **options }.compact)
        end

        # Sets the auto-apply opt-in status for recommendation types
        # (SetAutoApplyOptInStatus).
        #
        # +auto_apply_opt_in_status_inputs+:: List of auto-apply opt-in status input
        #                                     objects specifying the recommendation type and
        #                                     opt-in status.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an empty response on success.
        def set_auto_apply_opt_in_status(auto_apply_opt_in_status_inputs:, **options)
          post("/AutoApplyOptInStatus/Set",
               { auto_apply_opt_in_status_inputs: auto_apply_opt_in_status_inputs, **options }.compact)
        end
      end
    end
  end
end
