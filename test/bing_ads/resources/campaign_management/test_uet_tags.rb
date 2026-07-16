# frozen_string_literal: true

require "test_helper"

class TestUetTagsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/UetTags", { "UetTags" => [{ "Name" => "T" }] })
    sdk_client.campaign_management.uet_tags.create(uet_tags: [{ name: "T" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/UetTags/QueryByIds", { "TagIds" => [4] })
    sdk_client.campaign_management.uet_tags.find(tag_ids: [4])
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/UetTags", { "UetTags" => [{ "Id" => 4 }] })
    sdk_client.campaign_management.uet_tags.update(uet_tags: [{ "Id" => 4 }])
    assert_requested stub
  end

  def test_auth_key
    stub = stub_op(:post, "#{CM}/UetTagAuthKey/Query", { "TagId" => 4 })
    sdk_client.campaign_management.uet_tags.auth_key(tag_id: 4)
    assert_requested stub
  end
end
