# frozen_string_literal: true

require "test_helper"

class TestSharedEntitiesResource < Minitest::Test
  include ResourceTestHelper

  def shared_list
    { "Type" => "NegativeKeywordList", "Id" => 11 }
  end

  def test_create
    stub = stub_op(:post, "#{CM}/SharedEntity",
                   { "SharedEntity" => { "Type" => "NegativeKeywordList", "Name" => "L" },
                     "ListItems" => [{ "Type" => "NegativeKeyword", "Text" => "free" }] })
    sdk_client.campaign_management.shared_entities.create(
      shared_entity: { "Type" => "NegativeKeywordList", "Name" => "L" },
      list_items: [{ "Type" => "NegativeKeyword", "Text" => "free" }]
    )
    assert_requested stub
  end

  def test_list
    stub = stub_op(:post, "#{CM}/SharedEntities/QueryByAccountId",
                   { "SharedEntityType" => "NegativeKeywordList" })
    sdk_client.campaign_management.shared_entities.list(shared_entity_type: "NegativeKeywordList")
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/SharedEntities", { "SharedEntities" => [shared_list] })
    sdk_client.campaign_management.shared_entities.update(shared_entities: [shared_list])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/SharedEntities", { "SharedEntities" => [shared_list] })
    sdk_client.campaign_management.shared_entities.delete(shared_entities: [shared_list])
    assert_requested stub
  end

  def test_add_list_items
    stub = stub_op(:post, "#{CM}/ListItems",
                   { "ListItems" => [{ "Text" => "free" }], "SharedEntity" => shared_list })
    sdk_client.campaign_management.shared_entities.add_list_items(
      list_items: [{ "Text" => "free" }], shared_entity: shared_list
    )
    assert_requested stub
  end

  def test_list_items
    stub = stub_op(:post, "#{CM}/ListItems/QueryBySharedList", { "SharedEntity" => shared_list })
    sdk_client.campaign_management.shared_entities.list_items(shared_entity: shared_list)
    assert_requested stub
  end

  def test_delete_list_items
    stub = stub_op(:delete, "#{CM}/ListItems",
                   { "ListItemIds" => [5], "SharedEntity" => shared_list })
    sdk_client.campaign_management.shared_entities.delete_list_items(list_item_ids: [5], shared_entity: shared_list)
    assert_requested stub
  end

  def test_set_associations
    stub = stub_op(:post, "#{CM}/SharedEntityAssociations/Set",
                   { "Associations" => [{ "EntityId" => 9, "SharedEntityId" => 11 }] })
    sdk_client.campaign_management.shared_entities.set_associations(
      associations: [{ entity_id: 9, shared_entity_id: 11 }]
    )
    assert_requested stub
  end

  def test_associations_by_entity_ids
    stub = stub_op(:post, "#{CM}/SharedEntityAssociations/QueryByEntityIds",
                   { "EntityIds" => [9], "EntityType" => "Campaign",
                     "SharedEntityType" => "NegativeKeywordList" })
    sdk_client.campaign_management.shared_entities.associations_by_entity_ids(
      entity_ids: [9], entity_type: "Campaign", shared_entity_type: "NegativeKeywordList"
    )
    assert_requested stub
  end

  def test_associations_by_shared_entity_ids
    stub = stub_op(:post, "#{CM}/SharedEntityAssociations/QueryBySharedEntityIds",
                   { "SharedEntityIds" => [11], "EntityType" => "Campaign",
                     "SharedEntityType" => "NegativeKeywordList" })
    sdk_client.campaign_management.shared_entities.associations_by_shared_entity_ids(
      shared_entity_ids: [11], entity_type: "Campaign", shared_entity_type: "NegativeKeywordList"
    )
    assert_requested stub
  end

  def test_delete_associations
    stub = stub_op(:delete, "#{CM}/SharedEntityAssociations",
                   { "Associations" => [{ "EntityId" => 9, "SharedEntityId" => 11 }] })
    sdk_client.campaign_management.shared_entities.delete_associations(
      associations: [{ entity_id: 9, shared_entity_id: 11 }]
    )
    assert_requested stub
  end
end
