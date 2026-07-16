# frozen_string_literal: true

require "test_helper"
require "tmpdir"

class TestReportingResources < Minitest::Test
  include ResourceTestHelper

  RP = "https://reporting.api.bingads.microsoft.com/Reporting/v13"
  FILE_URL = "https://download.example.com/report.zip"

  def report_request
    { type: "CampaignPerformanceReportRequest", format: "Csv", aggregation: "Daily",
      columns: %w[TimePeriod Clicks], scope: { account_ids: [456] },
      time: { predefined_time: "LastMonth" } }
  end

  def stub_submit
    stub_request(:post, "#{RP}/GenerateReport/Submit")
      .with(body: hash_including("ReportRequest" => hash_including(
        "Type" => "CampaignPerformanceReportRequest",
        "Scope" => { "AccountIds" => [456] }
      )))
      .to_return(status: 200, body: JSON.generate("ReportRequestId" => "RRID-1"))
  end

  def stub_poll(*statuses)
    responses = statuses.map do |status, url|
      { status: 200, body: JSON.generate(
        "ReportRequestStatus" => { "Status" => status, "ReportDownloadUrl" => url }
      ) }
    end
    stub_request(:post, "#{RP}/GenerateReport/Poll")
      .with(body: JSON.generate("ReportRequestId" => "RRID-1"))
      .to_return(*responses)
  end

  def test_submit_returns_operation
    stub_submit
    operation = sdk_client.reporting.reports.submit(report_request)
    assert_equal "RRID-1", operation.request_id
  end

  def test_download_polls_downloads_and_decompresses
    stub_submit
    stub_poll(["Pending", nil], ["Pending", nil], %w[Success] << FILE_URL)

    Dir.mktmpdir do |dir|
      zip = File.join(dir, "src.zip")
      BingAds::Zip.create(zip, "report.csv", "A,B\n1,2\n")
      stub_request(:get, FILE_URL).to_return(status: 200, body: File.binread(zip))

      sleeps = []
      target = File.join(dir, "june.csv")
      path = BingAds::Polling.stub(:sleep, ->(s) { sleeps << s }) do
        sdk_client.reporting.reports.download(report_request, path: target)
      end
      assert_equal target, path
      assert_equal "A,B\n1,2\n", File.read(path)
      assert_equal [5, 5], sleeps # two Pending polls at the default interval
      assert_empty Dir.glob(File.join(dir, "*.zip")) - [zip] # no result zip left behind
    end
  end

  def test_download_without_decompress_keeps_zip
    stub_submit
    stub_poll(%w[Success] << FILE_URL)
    stub_request(:get, FILE_URL).to_return(status: 200, body: "ZIPBYTES")

    Dir.mktmpdir do |dir|
      target = File.join(dir, "june.zip")
      path = sdk_client.reporting.reports.download(report_request, path: target, decompress: false)
      assert_equal target, path
      assert_equal "ZIPBYTES", File.read(path)
    end
  end

  def test_error_status_raises_operation_failed
    stub_submit
    stub_poll(["Error", nil])
    error = assert_raises(BingAds::OperationFailedError) do
      sdk_client.reporting.reports.submit(report_request).track
    end
    assert_equal "Error", error.status
  end

  def test_success_without_url_returns_nil
    stub_submit
    stub_poll(["Success", nil])
    Dir.mktmpdir do |dir|
      assert_nil sdk_client.reporting.reports.download(report_request, path: File.join(dir, "x.csv"))
    end
  end
end
