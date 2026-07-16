# frozen_string_literal: true

module BingAds
  module Resources
    module Bulk
      # Tracks a submitted bulk download or upload: poll until terminal
      # status, then download (and optionally unzip) the result file.
      class Operation
        PENDING_STATUSES = {
          download: %w[Pending InProgress].freeze,
          upload: %w[PendingFileUpload FileUploaded InProgress].freeze
        }.freeze
        SUCCESS_STATUSES = {
          download: %w[Completed].freeze,
          upload: %w[Completed CompletedWithErrors].freeze
        }.freeze

        attr_reader :request_id, :kind

        # +client+:: BingAds::Client instance used to call the bulk API.
        # +request_id+:: The +DownloadRequestId+ or +RequestId+ returned by the submit operation.
        # +kind+:: Either +:download+ or +:upload+; controls which status endpoint and terminal
        #          statuses are used.
        def initialize(client, request_id, kind:)
          @client = client
          @request_id = request_id
          @kind = kind
        end

        # Fetches the current operation status from GetBulkDownloadStatus or GetBulkUploadStatus.
        #
        # Returns the raw status response object.
        def status
          if kind == :download
            @client.bulk.files.download_status(request_id: request_id)
          else
            @client.bulk.files.upload_status(request_id: request_id)
          end
        end

        # Polls until a success status (returns the final status object)
        # or a terminal failure (raises +OperationFailedError+).
        #
        # +interval+:: Optional. Seconds between polls (default 5).
        # +timeout+:: Optional. Maximum total seconds to wait before raising +Timeout::Error+ (default 3600).
        #
        # Returns the final status object on success.
        def track(interval: 5, timeout: 3600)
          @track ||= Polling.wait_for(interval: interval, timeout: timeout) do
            current = status
            state = current.request_status
            if PENDING_STATUSES.fetch(kind).include?(state)
              nil
            elsif SUCCESS_STATUSES.fetch(kind).include?(state)
              current
            else
              raise OperationFailedError.new(
                "bulk #{kind} failed with status #{state.inspect}",
                status: state, errors: current["Errors"]
              )
            end
          end
        end

        # Downloads the result file to exactly +path+ (the extracted CSV/TSV when
        # +decompress: true+, the raw ZIP otherwise), or returns nil when no result
        # file was produced.
        #
        # +path+:: Local filesystem path where the result file will be written.
        # +decompress+:: Optional. Extract the inner CSV/TSV from the ZIP when true (default true).
        # +overwrite+:: Optional. Raise an error if +path+ already exists when false (default false).
        # +interval+:: Optional. Seconds between polls (default 5).
        # +timeout+:: Optional. Maximum total seconds to wait before raising +Timeout::Error+ (default 3600).
        #
        # Returns the local file path string, or nil when no result file was produced.
        def download_result_file(path:, decompress: true, overwrite: false, interval: 5, timeout: 3600)
          final = track(interval: interval, timeout: timeout)
          url = final.result_file_url
          return if url.nil? || url.empty?

          ResultFile.fetch(@client.connection, url,
                           path: path, decompress: decompress, overwrite: overwrite)
        end
      end
    end
  end
end
