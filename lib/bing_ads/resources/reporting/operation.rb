# frozen_string_literal: true

module BingAds
  module Resources
    module Reporting
      # Tracks a submitted report request: poll until terminal status,
      # then download (and optionally unzip) the result file.
      class Operation
        attr_reader :request_id

        # +client+:: BingAds::Client instance used to call the reporting API.
        # +request_id+:: The +ReportRequestId+ returned by SubmitGenerateReport.
        def initialize(client, request_id)
          @client = client
          @request_id = request_id
        end

        # Polls until Success (returns the final status object) or a
        # terminal failure (raises +OperationFailedError+) (PollGenerateReport).
        #
        # +interval+:: Optional. Seconds between polls (default 5).
        # +timeout+:: Optional. Maximum total seconds to wait before raising +Timeout::Error+ (default 3600).
        #
        # Returns the final +ReportRequestStatus+ object on success.
        def track(interval: 5, timeout: 3600)
          @track ||= Polling.wait_for(interval: interval, timeout: timeout) do
            status = @client.reporting.reports.poll(request_id).report_request_status
            case status.status
            when "Pending" then nil
            when "Success" then status
            else
              raise OperationFailedError.new(
                "report generation failed with status #{status.status.inspect}",
                status: status.status
              )
            end
          end
        end

        # Downloads the result to exactly +path+ (the extracted CSV/TSV when
        # +decompress: true+, the raw ZIP otherwise) and returns it, or returns
        # nil when the report contains no data.
        #
        # +path+:: Local filesystem path where the result file will be written.
        # +decompress+:: Optional. Extract the inner CSV/TSV from the ZIP when true (default true).
        # +overwrite+:: Optional. Raise an error if +path+ already exists when false (default false).
        # +interval+:: Optional. Seconds between polls (default 5).
        # +timeout+:: Optional. Maximum total seconds to wait before raising +Timeout::Error+ (default 3600).
        #
        # Returns the local file path string, or nil when the report has no data.
        def download_result_file(path:, decompress: true, overwrite: false, interval: 5, timeout: 3600)
          status = track(interval: interval, timeout: timeout)
          url = status.report_download_url
          return if url.nil? || url.empty?

          ResultFile.fetch(@client.connection, url,
                           path: path, decompress: decompress, overwrite: overwrite)
        end
      end
    end
  end
end
