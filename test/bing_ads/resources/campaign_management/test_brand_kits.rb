# frozen_string_literal: true

require "test_helper"

class TestBrandKitsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/BrandKits", { "BrandKits" => [{ "Name" => "B" }] })
    sdk_client.campaign_management.brand_kits.create(brand_kits: [{ name: "B" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/BrandKits/QueryByIds", { "BrandKitIds" => [6] })
    sdk_client.campaign_management.brand_kits.find(brand_kit_ids: [6])
    assert_requested stub
  end

  def test_list
    stub = stub_op(:post, "#{CM}/BrandKits/QueryByAccountId", { "AccountId" => 456 })
    sdk_client.campaign_management.brand_kits.list
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/BrandKits", { "BrandKits" => [{ "Id" => 6 }] })
    sdk_client.campaign_management.brand_kits.update(brand_kits: [{ "Id" => 6 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/BrandKits", { "BrandKitIds" => [6] })
    sdk_client.campaign_management.brand_kits.delete(brand_kit_ids: [6])
    assert_requested stub
  end
end
