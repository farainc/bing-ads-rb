# frozen_string_literal: true

require "test_helper"

class TestEditorialResource < Minitest::Test
  include ResourceTestHelper

  def assocs
    [{ "EntityId" => 7, "ParentId" => 2 }]
  end

  def test_reasons_by_ids
    stub = stub_op(:post, "#{CM}/EditorialReasons/QueryByIds",
                   { "AccountId" => 456,
                     "EntityIdToParentIdAssociations" => assocs,
                     "EntityType" => "Ad" })
    sdk_client.campaign_management.editorial.reasons_by_ids(
      entity_id_to_parent_id_associations: assocs, entity_type: "Ad"
    )
    assert_requested stub
  end

  def test_appeal
    stub = stub_op(:post, "#{CM}/EditorialRejections/Appeal",
                   { "EntityIdToParentIdAssociations" => assocs,
                     "EntityType" => "Ad",
                     "JustificationText" => "please review" })
    sdk_client.campaign_management.editorial.appeal(
      entity_id_to_parent_id_associations: assocs, entity_type: "Ad",
      justification_text: "please review"
    )
    assert_requested stub
  end
end
