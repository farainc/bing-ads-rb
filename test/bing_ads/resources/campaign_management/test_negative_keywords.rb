# frozen_string_literal: true

require "test_helper"

class TestNegativeKeywordsResource < Minitest::Test
  include ResourceTestHelper

  def enks
    [{ "EntityId" => 9, "EntityType" => "Campaign", "NegativeKeywords" => [{ "Text" => "free" }] }]
  end

  def test_add_to_entities
    stub = stub_op(:post, "#{CM}/EntityNegativeKeywords", { "EntityNegativeKeywords" => enks })
    sdk_client.campaign_management.negative_keywords.add_to_entities(entity_negative_keywords: enks)
    assert_requested stub
  end

  def test_list_by_entity_ids
    stub = stub_op(:post, "#{CM}/NegativeKeywords/QueryByEntityIds",
                   { "EntityIds" => [9], "EntityType" => "Campaign", "ParentEntityId" => 456 })
    sdk_client.campaign_management.negative_keywords.list_by_entity_ids(
      entity_ids: [9], entity_type: "Campaign", parent_entity_id: 456
    )
    assert_requested stub
  end

  def test_delete_from_entities
    stub = stub_op(:delete, "#{CM}/EntityNegativeKeywords", { "EntityNegativeKeywords" => enks })
    sdk_client.campaign_management.negative_keywords.delete_from_entities(entity_negative_keywords: enks)
    assert_requested stub
  end
end
