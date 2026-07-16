# frozen_string_literal: true

require "test_helper"

class TestConversionValueRulesResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/ConversionValueRules",
                   { "ConversionValueRules" => [{ "Name" => "R" }] })
    sdk_client.campaign_management.conversion_value_rules.create(conversion_value_rules: [{ name: "R" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/ConversionValueRules/QueryByIds",
                   { "AccountId" => 456, "ConversionValueRuleIds" => [2] })
    sdk_client.campaign_management.conversion_value_rules.find(conversion_value_rule_ids: [2])
    assert_requested stub
  end

  def test_list
    stub = stub_op(:post, "#{CM}/ConversionValueRules/QueryByAccountId", { "AccountId" => 456 })
    sdk_client.campaign_management.conversion_value_rules.list
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/ConversionValueRules",
                   { "ConversionValueRules" => [{ "Id" => 2 }] })
    sdk_client.campaign_management.conversion_value_rules.update(conversion_value_rules: [{ "Id" => 2 }])
    assert_requested stub
  end

  def test_update_status
    stub = stub_op(:put, "#{CM}/ConversionValueRulesStatus",
                   { "ConversionValueRuleIds" => [2], "Status" => "Paused" })
    sdk_client.campaign_management.conversion_value_rules.update_status(
      conversion_value_rule_ids: [2], status: "Paused"
    )
    assert_requested stub
  end
end
