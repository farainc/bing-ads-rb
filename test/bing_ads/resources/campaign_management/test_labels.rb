# frozen_string_literal: true

require "test_helper"

class TestLabelsResource < Minitest::Test
  include ResourceTestHelper

  def label_assocs
    [{ "EntityId" => 9, "LabelId" => 7 }]
  end

  def test_create
    stub = stub_op(:post, "#{CM}/Labels", { "Labels" => [{ "Name" => "L" }] })
    sdk_client.campaign_management.labels.create(labels: [{ name: "L" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/Labels/QueryByIds",
                   { "LabelIds" => [7], "PageInfo" => { "Index" => 0, "Size" => 100 } })
    sdk_client.campaign_management.labels.find(label_ids: [7], page_info: { index: 0, size: 100 })
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/Labels", { "Labels" => [{ "Id" => 7 }] })
    sdk_client.campaign_management.labels.update(labels: [{ "Id" => 7 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Labels", { "LabelIds" => [7] })
    sdk_client.campaign_management.labels.delete(label_ids: [7])
    assert_requested stub
  end

  def test_set_associations
    stub = stub_op(:post, "#{CM}/LabelAssociations/Set",
                   { "EntityType" => "Campaign", "LabelAssociations" => label_assocs })
    sdk_client.campaign_management.labels.set_associations(label_associations: label_assocs, entity_type: "Campaign")
    assert_requested stub
  end

  def test_delete_associations
    stub = stub_op(:delete, "#{CM}/LabelAssociations",
                   { "EntityType" => "Campaign", "LabelAssociations" => label_assocs })
    sdk_client.campaign_management.labels.delete_associations(label_associations: label_assocs, entity_type: "Campaign")
    assert_requested stub
  end

  def test_associations_by_entity_ids
    stub = stub_op(:post, "#{CM}/LabelAssociations/QueryByEntityIds",
                   { "EntityIds" => [9], "EntityType" => "Campaign" })
    sdk_client.campaign_management.labels.associations_by_entity_ids(entity_ids: [9], entity_type: "Campaign")
    assert_requested stub
  end

  def test_associations_by_label_ids
    stub = stub_op(:post, "#{CM}/LabelAssociations/QueryByLabelIds",
                   { "LabelIds" => [7], "EntityType" => "Campaign" })
    sdk_client.campaign_management.labels.associations_by_label_ids(label_ids: [7], entity_type: "Campaign")
    assert_requested stub
  end
end
