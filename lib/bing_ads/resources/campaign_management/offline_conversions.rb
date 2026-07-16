# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Offline and online conversion ingestion
      # (ApplyOfflineConversions, ApplyOfflineConversionAdjustments,
      # ApplyOnlineConversionAdjustments).
      class OfflineConversions < Base
        service :campaign_management

        # Uploads offline conversions for attribution (ApplyOfflineConversions).
        #
        # +offline_conversions+:: Array of OfflineConversion objects to apply
        #                         (maximum 1,000 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def apply(offline_conversions:, **options)
          post("/OfflineConversions/Apply", { offline_conversions: offline_conversions, **options }.compact)
        end

        # Applies adjustments (retractions or restatements) to previously uploaded
        # offline conversions (ApplyOfflineConversionAdjustments).
        #
        # +offline_conversion_adjustments+:: Array of OfflineConversionAdjustment objects
        #                                    to apply (maximum 1,000 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def apply_adjustments(offline_conversion_adjustments:, **options)
          post("/OfflineConversionAdjustments/Apply",
               { offline_conversion_adjustments: offline_conversion_adjustments, **options }.compact)
        end

        # Applies adjustments to online conversions (ApplyOnlineConversionAdjustments).
        #
        # +online_conversion_adjustments+:: Array of OnlineConversionAdjustment objects
        #                                   to apply.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def apply_online_adjustments(online_conversion_adjustments:, **options)
          post("/OnlineConversionAdjustments/Apply",
               { online_conversion_adjustments: online_conversion_adjustments, **options }.compact)
        end

        # Queries offline conversion reports.
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns a paged list of offline conversion report records.
        def reports(**options)
          post("/OfflineConversionReports/Query", options)
        end

        # Queries offline conversion reports filtered by goal identifiers.
        #
        # +goal_ids+:: Array of conversion goal identifiers to filter by.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns a list of offline conversion report records for the given goals.
        def report_by_goal_ids(goal_ids:, **options)
          post("/OfflineConversionReport/QueryByGoalIds", { goal_ids: goal_ids, **options }.compact)
        end
      end
    end
  end
end
