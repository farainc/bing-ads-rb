# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Seasonality adjustment CRUD for Smart Bidding CVR corrections
      # (AddSeasonalityAdjustments, GetSeasonalityAdjustmentsByAccountId,
      # GetSeasonalityAdjustmentsByIds, UpdateSeasonalityAdjustments,
      # DeleteSeasonalityAdjustments).
      class SeasonalityAdjustments < Base
        service :campaign_management

        # Adds seasonality adjustments so that Smart Bidding accounts for expected
        # conversion rate changes during specific date ranges (AddSeasonalityAdjustments).
        #
        # +seasonality_adjustments+:: Array of SeasonalityAdjustment objects to add.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +seasonality_adjustment_ids+ and +partial_errors+.
        def create(seasonality_adjustments:, **options)
          post("/SeasonalityAdjustments", { seasonality_adjustments: seasonality_adjustments, **options }.compact)
        end

        # Gets all seasonality adjustments for an account
        # (GetSeasonalityAdjustmentsByAccountId).
        #
        # +account_id+:: Identifier of the account to query.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +seasonality_adjustments+.
        def list(account_id: client.account_id, **options)
          post("/SeasonalityAdjustments/QueryByAccountId", { account_id: account_id, **options }.compact)
        end

        # Gets seasonality adjustments by their identifiers
        # (GetSeasonalityAdjustmentsByIds).
        #
        # +seasonality_adjustment_ids+:: Array of seasonality adjustment identifiers
        #                                to retrieve.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +seasonality_adjustments+ and +partial_errors+.
        def find(seasonality_adjustment_ids:, **options)
          post("/SeasonalityAdjustments/QueryByIds",
               { seasonality_adjustment_ids: seasonality_adjustment_ids, **options }.compact)
        end

        # Updates seasonality adjustments (UpdateSeasonalityAdjustments).
        #
        # +seasonality_adjustments+:: Array of SeasonalityAdjustment objects to update;
        #                             each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(seasonality_adjustments:, **options)
          put("/SeasonalityAdjustments", { seasonality_adjustments: seasonality_adjustments, **options }.compact)
        end

        # Deletes seasonality adjustments (DeleteSeasonalityAdjustments).
        #
        # +seasonality_adjustment_ids+:: Array of seasonality adjustment identifiers to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(seasonality_adjustment_ids:, **options)
          request(:delete, "/SeasonalityAdjustments",
                  { seasonality_adjustment_ids: seasonality_adjustment_ids, **options }.compact)
        end
      end
    end
  end
end
