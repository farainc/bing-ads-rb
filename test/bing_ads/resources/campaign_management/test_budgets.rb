# frozen_string_literal: true

require "test_helper"

class TestBudgetsResource < Minitest::Test
  include ResourceTestHelper

  def test_create
    stub = stub_op(:post, "#{CM}/Budgets",
                   { "AccountId" => 456, "Budgets" => [{ "Name" => "B", "Amount" => 10 }] })
    sdk_client.campaign_management.budgets.create(budgets: [{ name: "B", amount: 10 }])
    assert_requested stub
  end

  def test_find
    stub = stub_op(:post, "#{CM}/Budgets/QueryByIds", { "AccountId" => 456, "BudgetIds" => [3] })
    sdk_client.campaign_management.budgets.find(budget_ids: [3])
    assert_requested stub
  end

  def test_update
    stub = stub_op(:put, "#{CM}/Budgets", { "AccountId" => 456, "Budgets" => [{ "Id" => 3 }] })
    sdk_client.campaign_management.budgets.update(budgets: [{ "Id" => 3 }])
    assert_requested stub
  end

  def test_delete
    stub = stub_op(:delete, "#{CM}/Budgets", { "AccountId" => 456, "BudgetIds" => [3] })
    sdk_client.campaign_management.budgets.delete(budget_ids: [3])
    assert_requested stub
  end

  def test_campaign_ids_by_budget_ids
    stub = stub_op(:post, "#{CM}/CampaignIds/QueryByBudgetIds", { "AccountId" => 456, "BudgetIds" => [3] })
    sdk_client.campaign_management.budgets.campaign_ids_by_budget_ids(budget_ids: [3])
    assert_requested stub
  end
end
