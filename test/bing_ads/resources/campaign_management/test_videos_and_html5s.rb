# frozen_string_literal: true

require "test_helper"

class TestVideosAndHTML5sResources < Minitest::Test
  include ResourceTestHelper

  def test_videos_create
    stub = stub_op(:post, "#{CM}/Videos", { "Videos" => [{ "Url" => "https://v" }] })
    sdk_client.campaign_management.videos.create(videos: [{ url: "https://v" }])
    assert_requested stub
  end

  def test_videos_find
    stub = stub_op(:post, "#{CM}/Videos/QueryByIds", { "VideoIds" => [1] })
    sdk_client.campaign_management.videos.find(video_ids: [1])
    assert_requested stub
  end

  def test_videos_update
    stub = stub_op(:put, "#{CM}/Videos", { "Videos" => [{ "Id" => 1 }] })
    sdk_client.campaign_management.videos.update(videos: [{ "Id" => 1 }])
    assert_requested stub
  end

  def test_videos_delete
    stub = stub_op(:delete, "#{CM}/Videos", { "VideoIds" => [1] })
    sdk_client.campaign_management.videos.delete(video_ids: [1])
    assert_requested stub
  end

  def test_html5s_create
    stub = stub_op(:post, "#{CM}/HTML5s", { "HTML5s" => [{ "Name" => "H" }] })
    sdk_client.campaign_management.html5s.create(html5s: [{ name: "H" }])
    assert_requested stub
  end

  def test_html5s_find
    stub = stub_op(:post, "#{CM}/HTML5s/QueryByIds", { "HTML5Ids" => [2] })
    sdk_client.campaign_management.html5s.find(html5_ids: [2])
    assert_requested stub
  end

  def test_html5s_delete
    stub = stub_op(:delete, "#{CM}/HTML5s", { "HTML5Ids" => [2] })
    sdk_client.campaign_management.html5s.delete(html5_ids: [2])
    assert_requested stub
  end
end
