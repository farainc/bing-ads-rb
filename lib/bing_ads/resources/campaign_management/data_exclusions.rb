# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Smart bidding data exclusion CRUD
      # (AddDataExclusions, GetDataExclusionsByAccountId, GetDataExclusionsByIds,
      # UpdateDataExclusions, DeleteDataExclusions).
      class DataExclusions < Base
        service :campaign_management

        # Adds data exclusions so that anomalous data periods are ignored by Smart Bidding
        # (AddDataExclusions).
        #
        # +data_exclusions+:: Array of DataExclusion objects to add.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +data_exclusion_ids+ and +partial_errors+.
        def create(data_exclusions:, **options)
          post("/DataExclusions", { data_exclusions: data_exclusions, **options }.compact)
        end

        # Gets all data exclusions for an account (GetDataExclusionsByAccountId).
        #
        # +account_id+:: Identifier of the account to query.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +data_exclusions+.
        def list(account_id: client.account_id, **options)
          post("/DataExclusions/QueryByAccountId", { account_id: account_id, **options }.compact)
        end

        # Gets data exclusions by their identifiers (GetDataExclusionsByIds).
        #
        # +data_exclusion_ids+:: Array of data exclusion identifiers to retrieve.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +data_exclusions+ and +partial_errors+.
        def find(data_exclusion_ids:, **options)
          post("/DataExclusions/QueryByIds", { data_exclusion_ids: data_exclusion_ids, **options }.compact)
        end

        # Updates data exclusions (UpdateDataExclusions).
        #
        # +data_exclusions+:: Array of DataExclusion objects to update;
        #                     each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(data_exclusions:, **options)
          put("/DataExclusions", { data_exclusions: data_exclusions, **options }.compact)
        end

        # Deletes data exclusions (DeleteDataExclusions).
        #
        # +data_exclusion_ids+:: Array of data exclusion identifiers to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(data_exclusion_ids:, **options)
          request(:delete, "/DataExclusions", { data_exclusion_ids: data_exclusion_ids, **options }.compact)
        end
      end
    end
  end
end
