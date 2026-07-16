# frozen_string_literal: true

require "test_helper"

class TestMediaResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/Media",
                   { "AccountId" => 456, "Media" => [{ "Type" => "Image" }] })
    sdk_client.campaign_management.media.create(media: [{ type: "Image" }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Media", { "AccountId" => 456, "MediaIds" => [9] })
    sdk_client.campaign_management.media.delete(media_ids: [9])
    assert_requested stub
  end

  def test_meta_data_by_account
    stub = stub_op(:post, "#{CM}/MediaMetaData/QueryByAccountId",
                   { "MediaEnabledEntities" => "ResponsiveAd" })
    sdk_client.campaign_management.media.meta_data_by_account(media_enabled_entities: "ResponsiveAd")
    assert_requested stub
  end

  def test_meta_data_by_ids
    stub = stub_op(:post, "#{CM}/MediaMetaData/QueryByIds", { "MediaIds" => [9] })
    sdk_client.campaign_management.media.meta_data_by_ids(media_ids: [9])
    assert_requested stub
  end
end
