# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class TestBulkResources < Minitest::Test
  include ResourceTestHelper

  BK = "https://bulk.api.bingads.microsoft.com/Bulk/v13"
  FILE_URL = "https://download.example.com/bulk.zip"
  UPLOAD_URL = "https://bulk.api.bingads.microsoft.com/upload/123"

  def test_download_by_account_ids_applies_defaults
    stub = stub_op(:post, "#{BK}/Campaigns/DownloadByAccountIds",
                   { "AccountIds" => [456], "DownloadEntities" => %w[Campaigns],
                     "CompressionType" => "Zip", "DownloadFileType" => "Csv",
                     "FormatVersion" => "6.0" })
    sdk_client.bulk.files.download_by_account_ids(entities: %w[Campaigns])
    assert_requested stub
  end

  def test_download_by_campaign_ids
    campaigns = [{ "CampaignId" => 9, "ParentAccountId" => 456 }]
    stub = stub_op(:post, "#{BK}/Campaigns/DownloadByCampaignIds",
                   { "Campaigns" => campaigns, "DownloadEntities" => %w[Keywords],
                     "CompressionType" => "Zip", "DownloadFileType" => "Csv",
                     "FormatVersion" => "6.0" })
    sdk_client.bulk.files.download_by_campaign_ids(campaigns: campaigns, entities: %w[Keywords])
    assert_requested stub
  end

  def test_status_and_upload_url_paths
    stub = stub_op(:post, "#{BK}/BulkDownloadStatus/Query", { "RequestId" => "R1" })
    sdk_client.bulk.files.download_status(request_id: "R1")
    assert_requested stub

    stub = stub_op(:post, "#{BK}/BulkUploadStatus/Query", { "RequestId" => "R2" })
    sdk_client.bulk.files.upload_status(request_id: "R2")
    assert_requested stub

    stub = stub_op(:post, "#{BK}/BulkUploadUrl/Query",
                   { "ResponseMode" => "ErrorsAndResults", "AccountId" => 456 })
    sdk_client.bulk.files.upload_url
    assert_requested stub
  end

  def test_managed_download_flow
    stub_request(:post, "#{BK}/Campaigns/DownloadByAccountIds")
      .to_return(status: 200, body: JSON.generate("DownloadRequestId" => "DR1"))
    stub_request(:post, "#{BK}/BulkDownloadStatus/Query")
      .with(body: JSON.generate("RequestId" => "DR1"))
      .to_return(
        { status: 200, body: JSON.generate("RequestStatus" => "InProgress", "PercentComplete" => 40) },
        { status: 200, body: JSON.generate("RequestStatus" => "Completed", "ResultFileUrl" => FILE_URL) }
      )

    Dir.mktmpdir do |dir|
      src = File.join(dir, "src.zip")
      BingAds::Zip.create(src, "bulk.csv", "Type,Id\nCampaign,1\n")
      stub_request(:get, FILE_URL).to_return(status: 200, body: File.binread(src))

      target = File.join(dir, "sync.csv")
      path = BingAds::Polling.stub(:sleep, ->(_s) {}) do
        sdk_client.bulk.files.download(path: target, entities: %w[Campaigns])
      end
      assert_equal target, path
      assert_equal "Type,Id\nCampaign,1\n", File.read(path)
    end
  end

  def test_download_failure_raises_operation_failed
    stub_request(:post, "#{BK}/Campaigns/DownloadByAccountIds")
      .to_return(status: 200, body: JSON.generate("DownloadRequestId" => "DR1"))
    stub_request(:post, "#{BK}/BulkDownloadStatus/Query")
      .to_return(status: 200, body: JSON.generate(
        "RequestStatus" => "FailedFullSyncRequired", "Errors" => [{ "Code" => 3222 }]
      ))
    error = assert_raises(BingAds::OperationFailedError) do
      sdk_client.bulk.files.submit_download(entities: %w[Campaigns]).track
    end
    assert_equal "FailedFullSyncRequired", error.status
    assert_equal [{ "Code" => 3222 }], error.errors
  end

  def test_managed_upload_flow_zips_csv_and_posts_multipart
    stub_request(:post, "#{BK}/BulkUploadUrl/Query")
      .to_return(status: 200, body: JSON.generate(
        "RequestId" => "UR1", "UploadUrl" => UPLOAD_URL
      ))
    upload_stub = stub_request(:post, UPLOAD_URL)
                  .with do |req|
                    req.headers["Authenticationtoken"] == "AT" &&
                      req.headers["Developertoken"] == "DT" &&
                      req.headers["Accountid"] == "456" &&
                      req.headers["Content-Type"].start_with?("multipart/form-data") &&
                      req.body.include?("PK") # local file header signature of embedded zip
                  end
                  .to_return(status: 200, body: "")
    stub_request(:post, "#{BK}/BulkUploadStatus/Query")
      .with(body: JSON.generate("RequestId" => "UR1"))
      .to_return(
        { status: 200, body: JSON.generate("RequestStatus" => "InProgress") },
        { status: 200, body: JSON.generate("RequestStatus" => "CompletedWithErrors",
                                           "ResultFileUrl" => FILE_URL) }
      )

    Dir.mktmpdir do |dir|
      csv = File.join(dir, "upload.csv")
      File.write(csv, "Type,Campaign\nFormat Version,6.0\n")

      result_zip = File.join(dir, "result_src.zip")
      BingAds::Zip.create(result_zip, "result.csv", "Type,Error\n")
      stub_request(:get, FILE_URL).to_return(status: 200, body: File.binread(result_zip))

      target = File.join(dir, "upload_result.csv")
      path = BingAds::Polling.stub(:sleep, ->(_s) {}) do
        sdk_client.bulk.files.upload(file: csv, result_path: target)
      end
      assert_requested upload_stub
      assert_equal target, path
      assert_equal "Type,Error\n", File.read(path)
    end
  end

  def test_upload_passes_existing_zip_through
    stub_request(:post, "#{BK}/BulkUploadUrl/Query")
      .to_return(status: 200, body: JSON.generate(
        "RequestId" => "UR2", "UploadUrl" => UPLOAD_URL
      ))
    upload_stub = stub_request(:post, UPLOAD_URL).to_return(status: 200, body: "")

    Dir.mktmpdir do |dir|
      zip = File.join(dir, "ready.zip")
      BingAds::Zip.create(zip, "u.csv", "Type\n")
      operation = sdk_client.bulk.files.submit_upload(file: zip)
      assert_equal "UR2", operation.request_id
      assert_requested upload_stub
      assert File.exist?(zip) # pre-zipped input is not deleted
    end
  end
end
