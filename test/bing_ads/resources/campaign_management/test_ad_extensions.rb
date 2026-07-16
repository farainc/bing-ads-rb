# frozen_string_literal: true

require "test_helper"

class TestAdExtensionsResource < Minitest::Test
  include ResourceTestHelper

  def assocs
    [{ "AdExtensionId" => 1, "EntityId" => 2 }]
  end

  def test_create
    stub = stub_op(:post, "#{CM}/AdExtensions",
                   { "AccountId" => 456, "AdExtensions" => [{ "Type" => "CalloutAdExtension" }] })
    sdk_client.campaign_management.ad_extensions.create(ad_extensions: [{ type: "CalloutAdExtension" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/AdExtensions/QueryByIds",
                   { "AccountId" => 456, "AdExtensionIds" => [1] })
    sdk_client.campaign_management.ad_extensions.find(ad_extension_ids: [1])
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/AdExtensions",
                   { "AccountId" => 456, "AdExtensions" => [{ "Id" => 1 }] })
    sdk_client.campaign_management.ad_extensions.update(ad_extensions: [{ "Id" => 1 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/AdExtensions",
                   { "AccountId" => 456, "AdExtensionIds" => [1] })
    sdk_client.campaign_management.ad_extensions.delete(ad_extension_ids: [1])
    assert_requested stub
  end

  def test_ids_by_account
    stub = stub_op(:post, "#{CM}/AdExtensionIds/QueryByAccountId",
                   { "AccountId" => 456, "AdExtensionType" => "SitelinkAdExtension" })
    sdk_client.campaign_management.ad_extensions.ids_by_account(ad_extension_type: "SitelinkAdExtension")
    assert_requested stub
  end

  def test_associations
    stub = stub_op(:post, "#{CM}/AdExtensionsAssociations/Query",
                   { "AccountId" => 456, "AssociationType" => "Campaign", "EntityIds" => [9] })
    sdk_client.campaign_management.ad_extensions.associations(association_type: "Campaign", entity_ids: [9])
    assert_requested stub
  end

  def test_set_associations
    stub = stub_op(:post, "#{CM}/AdExtensionsAssociations/Set",
                   { "AccountId" => 456,
                     "AdExtensionIdToEntityIdAssociations" => assocs,
                     "AssociationType" => "Campaign" })
    sdk_client.campaign_management.ad_extensions.set_associations(
      ad_extension_id_to_entity_id_associations: assocs, association_type: "Campaign"
    )
    assert_requested stub
  end

  def test_delete_associations
    stub = stub_op(:delete, "#{CM}/AdExtensionsAssociations",
                   { "AccountId" => 456,
                     "AdExtensionIdToEntityIdAssociations" => assocs,
                     "AssociationType" => "Campaign" })
    sdk_client.campaign_management.ad_extensions.delete_associations(
      ad_extension_id_to_entity_id_associations: assocs, association_type: "Campaign"
    )
    assert_requested stub
  end

  def test_editorial_reasons
    stub = stub_op(:post, "#{CM}/AdExtensionsEditorialReasons/Query",
                   { "AccountId" => 456, "AdExtensionIdToEntityIdAssociations" => assocs,
                     "AssociationType" => "Campaign" })
    sdk_client.campaign_management.ad_extensions.editorial_reasons(
      ad_extension_id_to_entity_id_associations: assocs, association_type: "Campaign"
    )
    assert_requested stub
  end
end
