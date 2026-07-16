# frozen_string_literal: true

require "securerandom"
require "tmpdir"

module BingAds
  module Resources
    module Bulk
      # Bulk service operations (named after the official operations)
      # plus the managed download/upload workflows.
      class Files < Base
        service :bulk

        OPERATION_OPTIONS = %i[decompress overwrite interval timeout].freeze

        # Submits a bulk download request by account IDs (DownloadCampaignsByAccountIds).
        #
        # +entities+:: Array of entity type strings to download, e.g. <tt>%w[Campaigns Keywords]</tt>.
        # +account_ids+:: Optional. Array of account identifiers to download; defaults to
        #                 <tt>[client.account_id]</tt>.
        # +compression_type+:: Optional. Compression format; defaults to <tt>"Zip"</tt>.
        # +data_scope+:: Optional. Scope filter, e.g. <tt>"EntityData"</tt>.
        # +download_file_type+:: Optional. File format; defaults to <tt>"Csv"</tt>.
        # +format_version+:: Optional. Bulk format version; defaults to <tt>"6.0"</tt>.
        # +last_sync_time_in_utc+:: Optional. ISO-8601 timestamp for incremental sync.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +download_request_id+ field.
        def download_by_account_ids(entities:, account_ids: [client.account_id], compression_type: "Zip",
                                    data_scope: nil, download_file_type: "Csv", format_version: "6.0",
                                    last_sync_time_in_utc: nil, **options)
          post("/Campaigns/DownloadByAccountIds",
               { account_ids: account_ids, download_entities: entities,
                 compression_type: compression_type, data_scope: data_scope,
                 download_file_type: download_file_type, format_version: format_version,
                 last_sync_time_in_utc: last_sync_time_in_utc, **options }.compact)
        end

        # Submits a bulk download request by campaign IDs (DownloadCampaignsByCampaignIds).
        #
        # +campaigns+:: Array of campaign selector hashes, each with <tt>CampaignId</tt> and
        #               <tt>ParentAccountId</tt>.
        # +entities+:: Array of entity type strings to download, e.g. <tt>%w[Campaigns Keywords]</tt>.
        # +compression_type+:: Optional. Compression format; defaults to <tt>"Zip"</tt>.
        # +data_scope+:: Optional. Scope filter, e.g. <tt>"EntityData"</tt>.
        # +download_file_type+:: Optional. File format; defaults to <tt>"Csv"</tt>.
        # +format_version+:: Optional. Bulk format version; defaults to <tt>"6.0"</tt>.
        # +last_sync_time_in_utc+:: Optional. ISO-8601 timestamp for incremental sync.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +download_request_id+ field.
        def download_by_campaign_ids(campaigns:, entities:, compression_type: "Zip", data_scope: nil,
                                     download_file_type: "Csv", format_version: "6.0",
                                     last_sync_time_in_utc: nil, **options)
          post("/Campaigns/DownloadByCampaignIds",
               { campaigns: campaigns, download_entities: entities,
                 compression_type: compression_type, data_scope: data_scope,
                 download_file_type: download_file_type, format_version: format_version,
                 last_sync_time_in_utc: last_sync_time_in_utc, **options }.compact)
        end

        # Retrieves the status of a bulk download request (GetBulkDownloadStatus).
        #
        # +request_id+:: The +DownloadRequestId+ returned by a download submission call.
        #
        # Returns an object with +request_status+, +percent_complete+, +result_file_url+, and
        # +errors+.
        def download_status(request_id:)
          post("/BulkDownloadStatus/Query", { request_id: request_id })
        end

        # Requests a pre-signed upload URL for a bulk file upload (GetBulkUploadUrl).
        #
        # +response_mode+:: Optional. Controls which rows appear in the result file; one of
        #                   <tt>"ErrorsOnly"</tt>, <tt>"ErrorsAndResults"</tt> (default).
        # +account_id+:: Optional. Account to upload into; defaults to the client's +account_id+.
        #
        # Returns an object with +request_id+ and +upload_url+.
        def upload_url(response_mode: "ErrorsAndResults", account_id: client.account_id)
          post("/BulkUploadUrl/Query", { response_mode: response_mode, account_id: account_id })
        end

        # Retrieves the status of a bulk upload request (GetBulkUploadStatus).
        #
        # +request_id+:: The +RequestId+ returned by +upload_url+.
        #
        # Returns an object with +request_status+ and +result_file_url+.
        def upload_status(request_id:)
          post("/BulkUploadStatus/Query", { request_id: request_id })
        end

        # Submits a bulk download request and returns a trackable operation handle.
        # Calls +download_by_campaign_ids+ when +campaigns:+ is provided, otherwise
        # +download_by_account_ids+.
        #
        # +campaigns+:: Optional. Array of campaign selector hashes; when present, scopes the
        #               download to specific campaigns.
        # +entities+:: Array of entity type strings to download.
        # +account_ids+:: Optional. Array of account identifiers (only used when +campaigns+ is nil).
        # +data_scope+:: Optional. Scope filter passed through to the download operation.
        # +download_file_type+:: Optional. File format override.
        # +last_sync_time_in_utc+:: Optional. ISO-8601 timestamp for incremental sync.
        # +options+:: Optional. Any additional fields forwarded to the download operation.
        #
        # Returns a +Bulk::Operation+ with +kind: :download+.
        def submit_download(campaigns: nil, **options)
          response = if campaigns
                       download_by_campaign_ids(campaigns: campaigns, **options)
                     else
                       download_by_account_ids(**options)
                     end
          Operation.new(client, response.download_request_id, kind: :download)
        end

        # Submits, polls, and downloads a bulk file in one call. Returns the local file path
        # of the bulk file.
        #
        # +path+:: Local filesystem path where the downloaded bulk file will be written.
        # +campaigns+:: Optional. Array of campaign selector hashes to scope the download.
        # +entities+:: Array of entity type strings to include in the download.
        # +account_ids+:: Optional. Array of account identifiers (unused when +campaigns+ is given).
        # +decompress+:: Optional. Extract the inner CSV/TSV from the ZIP when true (default true).
        # +overwrite+:: Optional. Raise an error if +path+ already exists when false (default false).
        # +interval+:: Optional. Seconds between polls (default 5).
        # +timeout+:: Optional. Maximum total seconds to wait before raising +Timeout::Error+ (default 3600).
        #
        # Returns the local file path string.
        def download(path:, **options)
          operation_options = options.slice(*OPERATION_OPTIONS)
          submit_download(**options.except(*OPERATION_OPTIONS))
            .download_result_file(path: path, **operation_options)
        end

        # Uploads a bulk file (bare CSV/TSV files are zipped with a UTF-8 BOM automatically)
        # and returns a trackable operation handle (GetBulkUploadUrl + multipart POST).
        #
        # +file+:: Local path to the CSV/TSV or ZIP file to upload.
        # +response_mode+:: Optional. Controls which rows appear in the result file; defaults to
        #                   <tt>"ErrorsAndResults"</tt>.
        # +account_id+:: Optional. Account to upload into; defaults to the client's +account_id+.
        #
        # Returns a +Bulk::Operation+ with +kind: :upload+.
        def submit_upload(file:, response_mode: "ErrorsAndResults", account_id: client.account_id)
          url_response = upload_url(response_mode: response_mode, account_id: account_id)
          perform_file_upload(url_response.upload_url, file, account_id)
          Operation.new(client, url_response.request_id, kind: :upload)
        end

        # Uploads a bulk file, polls until complete, and downloads the result file
        # (GetBulkUploadUrl + multipart POST + GetBulkUploadStatus + file download).
        #
        # +file+:: Local path to the CSV/TSV or ZIP file to upload.
        # +result_path+:: Local filesystem path where the upload result file will be written.
        # +response_mode+:: Optional. Controls which rows appear in the result; defaults to
        #                   <tt>"ErrorsAndResults"</tt>.
        # +account_id+:: Optional. Account to upload into; defaults to the client's +account_id+.
        # +decompress+:: Optional. Extract the inner CSV/TSV from the ZIP when true (default true).
        # +overwrite+:: Optional. Raise an error if +result_path+ already exists when false
        #               (default false).
        # +interval+:: Optional. Seconds between polls (default 5).
        # +timeout+:: Optional. Maximum total seconds to wait before raising +Timeout::Error+
        #             (default 3600).
        #
        # Returns the local result file path string.
        def upload(file:, result_path:, **options)
          operation_options = options.slice(*OPERATION_OPTIONS)
          submit_upload(file: file, **options.except(*OPERATION_OPTIONS))
            .download_result_file(path: result_path, **operation_options)
        end

        private

        # The pre-signed upload URL takes multipart/form-data with the
        # legacy AuthenticationToken header (not Authorization: Bearer).
        def perform_file_upload(upload_url, file, account_id)
          zip_path, temporary = ensure_zip(file)
          uri = URI(upload_url)
          boundary = "----BingAdsRuby#{SecureRandom.hex(12)}"
          request = Net::HTTP::Post.new(uri)
          request["AuthenticationToken"] = client.oauth.access_token!
          request["DeveloperToken"] = client.developer_token
          request["CustomerId"] = client.customer_id.to_s
          request["AccountId"] = account_id.to_s
          request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
          request.body = multipart_body(boundary, zip_path)
          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
            http.request(request)
          end
          raise HTTPError.from_response(response) unless response.is_a?(Net::HTTPSuccess)
        ensure
          File.delete(zip_path) if temporary && zip_path && File.exist?(zip_path)
        end

        def ensure_zip(file)
          return [file, false] if File.extname(file).casecmp(".zip").zero?

          data = File.binread(file)
          bom = "\xEF\xBB\xBF".b
          data = bom + data unless data.start_with?(bom)
          zip_path = File.join(Dir.tmpdir, "bulk_upload_#{SecureRandom.hex(6)}.zip")
          BingAds::Zip.create(zip_path, File.basename(file), data)
          [zip_path, true]
        end

        def multipart_body(boundary, zip_path)
          body = "--#{boundary}\r\n"
          body << "Content-Disposition: form-data; name=\"file\"; " \
                  "filename=\"#{File.basename(zip_path)}\"\r\n"
          body << "Content-Type: application/zip\r\n\r\n"
          body << File.binread(zip_path)
          body << "\r\n--#{boundary}--\r\n"
          body
        end
      end
    end
  end
end
