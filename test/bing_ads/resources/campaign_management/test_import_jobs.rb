# frozen_string_literal: true

require "test_helper"

class TestImportJobsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/ImportJobs",
                   { "ImportJobs" => [{ "Type" => "GoogleImportJob" }] })
    sdk_client.campaign_management.import_jobs.create(import_jobs: [{ type: "GoogleImportJob" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/ImportJobs/QueryByIds",
                   { "ImportJobIds" => [3], "ImportType" => "GoogleImportJob" })
    sdk_client.campaign_management.import_jobs.find(import_job_ids: [3], import_type: "GoogleImportJob")
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/ImportJobs", { "ImportJobs" => [{ "Id" => 3 }] })
    sdk_client.campaign_management.import_jobs.update(import_jobs: [{ "Id" => 3 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/ImportJobs",
                   { "ImportJobIds" => [3], "ImportType" => "GoogleImportJob" })
    sdk_client.campaign_management.import_jobs.delete(import_job_ids: [3], import_type: "GoogleImportJob")
    assert_requested stub
  end

  def test_results
    stub = stub_op(:post, "#{CM}/ImportResults/Query",
                   { "ImportType" => "GoogleImportJob", "ImportJobIds" => [3] })
    sdk_client.campaign_management.import_jobs.results(import_type: "GoogleImportJob", import_job_ids: [3])
    assert_requested stub
  end

  def test_file_upload_url
    stub = stub_op(:post, "#{CM}/FileImportUploadUrl/Query", {})
    sdk_client.campaign_management.import_jobs.file_upload_url
    assert_requested stub
  end

  def test_entity_ids_mapping
    stub = stub_op(:post, "#{CM}/ImportEntityIdsMapping/Query",
                   { "ImportType" => "GoogleImportJob", "ImportEntityType" => "Campaign" })
    sdk_client.campaign_management.import_jobs.entity_ids_mapping(
      import_type: "GoogleImportJob", import_entity_type: "Campaign"
    )
    assert_requested stub
  end
end
