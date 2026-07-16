# frozen_string_literal: true

require "test_helper"

class TestBidStrategiesResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/BidStrategies",
                   { "AccountId" => 456, "BidStrategies" => [{ "Name" => "S" }] })
    sdk_client.campaign_management.bid_strategies.create(bid_strategies: [{ name: "S" }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/BidStrategies/QueryByIds",
                   { "AccountId" => 456, "BidStrategyIds" => [4] })
    sdk_client.campaign_management.bid_strategies.find(bid_strategy_ids: [4])
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/BidStrategies",
                   { "AccountId" => 456, "BidStrategies" => [{ "Id" => 4 }] })
    sdk_client.campaign_management.bid_strategies.update(bid_strategies: [{ "Id" => 4 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/BidStrategies",
                   { "AccountId" => 456, "BidStrategyIds" => [4] })
    sdk_client.campaign_management.bid_strategies.delete(bid_strategy_ids: [4])
    assert_requested stub
  end
end
