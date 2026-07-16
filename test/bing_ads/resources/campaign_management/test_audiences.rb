# frozen_string_literal: true

require "test_helper"

class TestAudiencesResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/Audiences",
                   { "Audiences" => [{ "Type" => "CustomerList", "Name" => "L" }] })
    sdk_client.campaign_management.audiences.create(audiences: [{ type: "CustomerList", name: "L" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/Audiences/QueryByIds",
                   { "AudienceIds" => [8], "Type" => "RemarketingList" })
    sdk_client.campaign_management.audiences.find(audience_ids: [8], type: "RemarketingList")
    assert_requested stub
  end

  def test_find_compacts_nil_ids
    stub = stub_op(:post, "#{CM}/Audiences/QueryByIds", { "Type" => "CustomerList" })
    sdk_client.campaign_management.audiences.find(type: "CustomerList")
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/Audiences", { "Audiences" => [{ "Id" => 8 }] })
    sdk_client.campaign_management.audiences.update(audiences: [{ "Id" => 8 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Audiences", { "AudienceIds" => [8] })
    sdk_client.campaign_management.audiences.delete(audience_ids: [8])
    assert_requested stub
  end

  def test_apply_customer_list_items
    stub = stub_op(:post, "#{CM}/CustomerListItems/Apply",
                   { "CustomerListItems" => [{ "Text" => "a@b.c" }] })
    sdk_client.campaign_management.audiences.apply_customer_list_items(customer_list_items: [{ "Text" => "a@b.c" }])
    assert_requested stub
  end

  def test_apply_customer_list_user_data
    stub = stub_op(:post, "#{CM}/CustomerListUserData/Apply",
                   { "CustomerListUserData" => { "ActionType" => "Add" } })
    sdk_client.campaign_management.audiences.apply_customer_list_user_data(
      customer_list_user_data: { "ActionType" => "Add" }
    )
    assert_requested stub
  end
end
