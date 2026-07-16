# frozen_string_literal: true

module BingAds
  module Resources
    module Reporting
      # SubmitGenerateReport / PollGenerateReport plus the managed
      # download workflow (Python SDK's ReportingServiceManager).
      class Reports < Base
        service :reporting

        # Submits a report generation request and returns a trackable operation handle
        # (SubmitGenerateReport).
        #
        # +report_request+:: A ReportRequest object hash (e.g. +CampaignPerformanceReportRequest+)
        #                    describing the report type, columns, scope, time range, and format.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns a +Reporting::Operation+ with the assigned +request_id+.
        def submit(report_request, **options)
          response = post("/GenerateReport/Submit",
                          { report_request: report_request, **options })
          Operation.new(client, response.report_request_id)
        end

        # Polls the status of a previously submitted report request (PollGenerateReport).
        #
        # +report_request_id+:: The +ReportRequestId+ string returned by +submit+.
        #
        # Returns an object with a +report_request_status+ field containing +status+ and
        # +report_download_url+.
        def poll(report_request_id)
          post("/GenerateReport/Poll", { report_request_id: report_request_id })
        end

        # Submits, polls, and downloads a report in one call (SubmitGenerateReport +
        # PollGenerateReport + file download). The result lands at exactly +path+.
        #
        # +report_request+:: A ReportRequest object hash describing the report to generate.
        # +path+:: Local filesystem path where the result file will be written.
        # +decompress+:: Optional. Extract the inner CSV/TSV from the ZIP when true (default true).
        # +overwrite+:: Optional. Raise an error if +path+ already exists when false (default false).
        # +interval+:: Optional. Seconds between polls (default 5).
        # +timeout+:: Optional. Maximum total seconds to wait before raising +Timeout::Error+ (default 3600).
        #
        # Returns the local file path string, or nil when the report has no data.
        def download(report_request, path:, **options)
          download_options = options.slice(:decompress, :overwrite, :interval, :timeout)
          submit(report_request, **options.except(*download_options.keys))
            .download_result_file(path: path, **download_options)
        end
      end
    end
  end
end
