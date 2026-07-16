# frozen_string_literal: true

require "test_helper"

class TestNcaAndLinkedInResources < Minitest::Test
  include ResourceTestHelper

  def test_nca_create
    stub = stub_op(:post, "#{CM}/NewCustomerAcquisitionGoals",
                   { "NewCustomerAcquisitionGoals" => [{ "Name" => "N" }] })
    sdk_client.campaign_management.new_customer_acquisition_goals.create(
      new_customer_acquisition_goals: [{ name: "N" }]
    )
    assert_requested stub
  end

  def test_nca_list
    stub = stub_op(:post, "#{CM}/NewCustomerAcquisitionGoals/QueryByAccountId",
                   { "AccountId" => 456 })
    sdk_client.campaign_management.new_customer_acquisition_goals.list
    assert_requested stub
  end

  def test_nca_update
    stub = stub_op(:put, "#{CM}/NewCustomerAcquisitionGoals",
                   { "NewCustomerAcquisitionGoals" => [{ "Id" => 1 }] })
    sdk_client.campaign_management.new_customer_acquisition_goals.update(
      new_customer_acquisition_goals: [{ "Id" => 1 }]
    )
    assert_requested stub
  end

  def test_linkedin_create
    stub = stub_op(:post, "#{CM}/LinkedInSegments", { "LinkedInSegments" => [{ "Name" => "L" }] })
    sdk_client.campaign_management.linked_in_segments.create(linked_in_segments: [{ name: "L" }])
    assert_requested stub
  end

  def test_linkedin_update
    stub = stub_op(:put, "#{CM}/LinkedInSegments", { "LinkedInSegments" => [{ "Id" => 3 }] })
    sdk_client.campaign_management.linked_in_segments.update(linked_in_segments: [{ "Id" => 3 }])
    assert_requested stub
  end

  def test_linkedin_delete
    stub = stub_op(:delete, "#{CM}/LinkedInSegments", { "LinkedInSegmentIds" => [3] })
    sdk_client.campaign_management.linked_in_segments.delete(linked_in_segment_ids: [3])
    assert_requested stub
  end

  def test_search_companies
    stub = stub_op(:post, "#{CM}/Companies/Search", { "CompanyNameFilter" => "Contoso" })
    sdk_client.campaign_management.linked_in_segments.search_companies(company_name_filter: "Contoso")
    assert_requested stub
  end
end
