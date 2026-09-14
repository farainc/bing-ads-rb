# frozen_string_literal: true

require "test_helper"

class TestAccountPropertiesResource < Minitest::Test
  include ResourceTestHelper

  def test_find_posts_the_property_names_to_query
    stub = stub_op(:post, "#{CM}/AccountProperties/Query",
                   { "AccountPropertyNames" => %w[TrackingUrlTemplate FinalUrlSuffix] })
    sdk_client.campaign_management.account_properties.find(names: %w[TrackingUrlTemplate FinalUrlSuffix])
    assert_requested stub
  end

  def test_find_wraps_the_returned_properties
    stub_request(:post, "#{CM}/AccountProperties/Query").to_return(
      status: 200,
      body: JSON.generate("AccountProperties" => [{ "Name" => "TrackingUrlTemplate", "Value" => "{lpurl}?tid=1" }],
                          "PartialErrors" => [])
    )
    response = sdk_client.campaign_management.account_properties.find(names: %w[TrackingUrlTemplate])
    assert_equal "{lpurl}?tid=1", response.account_properties.first.value
    assert_equal "TrackingUrlTemplate", response["AccountProperties"].first["Name"]
  end

  def test_update_posts_name_value_pairs_to_set
    stub = stub_op(:post, "#{CM}/AccountProperties/Set",
                   { "AccountProperties" => [{ "Name" => "TrackingUrlTemplate", "Value" => "{lpurl}?tid=1" },
                                             { "Name" => "FinalUrlSuffix", "Value" => "" }] })
    sdk_client.campaign_management.account_properties.update(
      properties: [{ name: "TrackingUrlTemplate", value: "{lpurl}?tid=1" }, { name: "FinalUrlSuffix", value: "" }]
    )
    assert_requested stub
  end
end
