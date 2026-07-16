# frozen_string_literal: true

require "test_helper"

class TestKeywordsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/Keywords",
                   { "AdGroupId" => 2, "Keywords" => [{ "Text" => "shoes", "MatchType" => "Exact" }] })
    sdk_client.campaign_management.keywords.create(keywords: [{ text: "shoes", match_type: "Exact" }], ad_group_id: 2)
    assert_requested stub
  end

  def test_list
    stub = stub_op(:post, "#{CM}/Keywords/QueryByAdGroupId", { "AdGroupId" => 2 })
    sdk_client.campaign_management.keywords.list(ad_group_id: 2)
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/Keywords/QueryByIds", { "AdGroupId" => 2, "KeywordIds" => [5] })
    sdk_client.campaign_management.keywords.find(keyword_ids: [5], ad_group_id: 2)
    assert_requested stub
  end

  def test_list_by_editorial_status
    stub = stub_op(:post, "#{CM}/Keywords/QueryByEditorialStatus",
                   { "AdGroupId" => 2, "EditorialStatus" => "ActiveAndPending" })
    sdk_client.campaign_management.keywords.list_by_editorial_status(editorial_status: "ActiveAndPending",
                                                                     ad_group_id: 2)
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/Keywords", { "AdGroupId" => 2, "Keywords" => [{ "Id" => 5 }] })
    sdk_client.campaign_management.keywords.update(keywords: [{ "Id" => 5 }], ad_group_id: 2)
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Keywords", { "AdGroupId" => 2, "KeywordIds" => [5] })
    sdk_client.campaign_management.keywords.delete(keyword_ids: [5], ad_group_id: 2)
    assert_requested stub
  end
end
