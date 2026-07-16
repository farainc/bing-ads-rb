# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Import job CRUD and results (AddImportJobs, GetImportJobsByIds, UpdateImportJobs,
      # DeleteImportJobs, GetImportResults, GetImportEntityIdsMapping).
      class ImportJobs < Base
        service :campaign_management

        # Creates one or more import jobs in the account (AddImportJobs).
        #
        # +import_jobs+:: Array of ImportJob objects to create (maximum one GoogleImportJob per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +import_job_ids+ and +partial_errors+.
        def create(import_jobs:, **options)
          post("/ImportJobs", { import_jobs: import_jobs, **options }.compact)
        end

        # Gets import jobs by type and optional IDs (GetImportJobsByIds).
        #
        # +import_type+::              Type of import job to retrieve (e.g. <tt>"GoogleImportJob"</tt>).
        # +import_job_ids+::           Optional. Array of import job IDs to retrieve (maximum 100).
        #                              If omitted, returns up to 500 jobs in the account.
        # +return_additional_fields+:: Optional. Flags to request additional fields not returned by default.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +import_jobs+ and +partial_errors+.
        def find(import_type:, import_job_ids: nil, return_additional_fields: nil, **options)
          post("/ImportJobs/QueryByIds",
               { import_job_ids: import_job_ids, import_type: import_type,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Replaces one or more import jobs with updated definitions (UpdateImportJobs).
        #
        # +import_jobs+:: Array of ImportJob objects to update (maximum one GoogleImportJob per call);
        #                 each must include its +Id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +import_job_ids+ (replacement IDs) and +partial_errors+.
        def update(import_jobs:, **options)
          put("/ImportJobs", { import_jobs: import_jobs, **options }.compact)
        end

        # Deletes import jobs by IDs and type (DeleteImportJobs).
        #
        # +import_job_ids+:: Array of import job IDs to delete.
        # +import_type+::    Type of import job to delete (e.g. <tt>"GoogleImportJob"</tt>).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(import_job_ids:, import_type:, **options)
          request(:delete, "/ImportJobs",
                  { import_job_ids: import_job_ids, import_type: import_type, **options }.compact)
        end

        # Gets results for import jobs completed within the last 90 days (GetImportResults).
        #
        # +import_type+::              Type of import job to query results for (e.g. <tt>"GoogleImportJob"</tt>).
        # +import_job_ids+::           Optional. Array of import job IDs to filter results (maximum 100).
        #                              If omitted, returns results for all jobs in the account.
        # +page_info+::                Optional. Paging object with +index+ and +size+ to paginate results.
        # +return_additional_fields+:: Optional. Additional fields to include in each result.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +import_results+.
        def results(import_type:, import_job_ids: nil, page_info: nil, return_additional_fields: nil, **options)
          post("/ImportResults/Query",
               { import_type: import_type, import_job_ids: import_job_ids,
                 page_info: page_info, return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Requests an upload URL for a file-based import (FileImportUploadUrl query).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with the upload URL.
        def file_upload_url(**options)
          post("/FileImportUploadUrl/Query", { **options }.compact)
        end

        # Gets source-to-Microsoft Advertising entity ID mappings (GetImportEntityIdsMapping).
        #
        # +import_type+::        Type of import job (e.g. <tt>"GoogleImportJob"</tt>).
        # +import_entity_type+:: Optional. Entity type to map (e.g. <tt>"Campaign"</tt>).
        # +source_entity_ids+::  Optional. Array of source entity IDs to map (maximum 100).
        # +source_parent_id+::   Optional. ID of the source parent entity.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +entity_ids_mapping+ and +partial_errors+.
        def entity_ids_mapping(import_type:, import_entity_type: nil, source_entity_ids: nil,
                               source_parent_id: nil, **options)
          post("/ImportEntityIdsMapping/Query",
               { import_type: import_type, import_entity_type: import_entity_type,
                 source_entity_ids: source_entity_ids, source_parent_id: source_parent_id, **options }.compact)
        end
      end
    end
  end
end
