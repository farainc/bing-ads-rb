# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Experiment CRUD (AddExperiments, GetExperimentsByIds,
      # UpdateExperiments, DeleteExperiments).
      class Experiments < Base
        service :campaign_management

        # Adds experiments and creates experiment campaigns based on existing campaigns
        # (AddExperiments).
        #
        # +experiments+:: Array of Experiment objects to add (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +experiment_ids+ and +partial_errors+.
        def create(experiments:, **options)
          post("/Experiments", { experiments: experiments, **options }.compact)
        end

        # Gets experiments by their identifiers (GetExperimentsByIds).
        #
        # +experiment_ids+::           Optional. Array of experiment identifiers (maximum 5,000).
        #                              If nil, all active experiments in the account are returned.
        # +page_info+::                Optional. Paging object reserved for future use.
        # +return_additional_fields+:: Optional. Additional Experiment properties to include.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +experiments+ and +partial_errors+.
        def find(experiment_ids: nil, page_info: nil, return_additional_fields: nil, **options)
          post("/Experiments/QueryByIds",
               { experiment_ids: experiment_ids, page_info: page_info,
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
        end

        # Updates existing experiments (UpdateExperiments).
        #
        # +experiments+:: Array of Experiment objects to update (maximum 100 per call);
        #                 each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(experiments:, **options)
          put("/Experiments", { experiments: experiments, **options }.compact)
        end

        # Deletes experiments by identifier (DeleteExperiments).
        #
        # +experiment_ids+:: Array of experiment identifiers to delete (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(experiment_ids:, **options)
          request(:delete, "/Experiments", { experiment_ids: experiment_ids, **options }.compact)
        end
      end
    end
  end
end
