# frozen_string_literal: true

require "test_helper"

class TestCustomerBillingResources < Minitest::Test
  include ResourceTestHelper

  CB = "https://clientcenter.api.bingads.microsoft.com/CustomerBilling/v13"

  def test_billing_documents
    docs_info = [{ "CustomerId" => 1, "DocumentId" => "d1" }]
    stub = stub_op(:post, "#{CB}/BillingDocuments/Query",
                   { "BillingDocumentsInfo" => docs_info, "Type" => "Pdf" })
    sdk_client.customer_billing.billing_documents.list(billing_documents_info: docs_info, type: "Pdf")
    assert_requested stub

    stub = stub_op(:post, "#{CB}/BillingDocumentsInfo/Query",
                   { "AccountIds" => [456], "StartDate" => "2026-01-01" })
    sdk_client.customer_billing.billing_documents.info(account_ids: [456], start_date: "2026-01-01")
    assert_requested stub

    stub = stub_op(:post, "#{CB}/AccountMonthlySpend/Query",
                   { "AccountId" => 456, "MonthYear" => "2026-06" })
    sdk_client.customer_billing.billing_documents.monthly_spend(account_id: 456, month_year: "2026-06")
    assert_requested stub
  end

  def test_billing_receives_customer_headers
    stub = stub_request(:post, "#{CB}/AccountMonthlySpend/Query")
           .with(headers: { "CustomerId" => "123", "CustomerAccountId" => "456" })
           .to_return(status: 200, body: "{}")
    sdk_client.customer_billing.billing_documents.monthly_spend(account_id: 456, month_year: "2026-06")
    assert_requested stub
  end

  def test_insertion_orders
    order = { "AccountId" => 456 }
    stub = stub_op(:post, "#{CB}/InsertionOrder", { "InsertionOrder" => order })
    sdk_client.customer_billing.insertion_orders.create(insertion_order: order)
    assert_requested stub

    stub = stub_op(:put, "#{CB}/InsertionOrder", { "InsertionOrder" => order })
    sdk_client.customer_billing.insertion_orders.update(insertion_order: order)
    assert_requested stub

    predicates = [{ "Field" => "AccountId", "Operator" => "Equals", "Value" => "456" }]
    paging = { "Index" => 0, "Size" => 10 }
    stub = stub_op(:post, "#{CB}/InsertionOrders/Search",
                   { "Predicates" => predicates, "PageInfo" => paging })
    sdk_client.customer_billing.insertion_orders.search(predicates: predicates, page_info: paging)
    assert_requested stub
  end

  def test_billing_groups
    { list: "BillingGroups/Query",
      ungrouped_accounts: "UngroupedAccounts/Query" }.each do |method, path|
      stub = stub_op(:post, "#{CB}/#{path}")
      sdk_client.customer_billing.billing_groups.public_send(method)
      assert_requested stub
    end

    stub = stub_op(:put, "#{CB}/BillingGroupAccounts")
    sdk_client.customer_billing.billing_groups.update_accounts
    assert_requested stub
  end

  def test_coupons
    stub = stub_op(:post, "#{CB}/Coupon/Redeem",
                   { "AccountId" => 456, "CouponCode" => "SAVE10" })
    sdk_client.customer_billing.coupons.redeem(account_id: 456, coupon_code: "SAVE10")
    assert_requested stub

    predicates = [{ "Field" => "CustomerId", "Operator" => "Equals", "Value" => "3" }]
    paging = { "Index" => 0, "Size" => 10 }
    stub = stub_op(:post, "#{CB}/Coupons/Search",
                   { "Predicates" => predicates, "PageInfo" => paging })
    sdk_client.customer_billing.coupons.search(predicates: predicates, page_info: paging)
    assert_requested stub

    stub = stub_op(:post, "#{CB}/CouponInfo/Query", { "CustomerId" => 3 })
    sdk_client.customer_billing.coupons.info(customer_id: 3)
    assert_requested stub

    stub = stub_op(:post, "#{CB}/Coupons/Dispatch",
                   { "SendToEmails" => ["a@b.c"], "CustomerId" => 3,
                     "CouponClassName" => "MyClass" })
    sdk_client.customer_billing.coupons.dispatch_coupons(
      send_to_emails: ["a@b.c"], customer_id: 3, coupon_class_name: "MyClass"
    )
    assert_requested stub

    { distribute: "Coupons/Distribute",
      check_feature_adoption_eligibility: "FeatureAdoptionCouponEligibility/Check",
      claim_feature_adoption: "FeatureAdoptionCoupons/Claim" }.each do |method, path|
      stub = stub_op(:post, "#{CB}/#{path}")
      sdk_client.customer_billing.coupons.public_send(method)
      assert_requested stub
    end
  end
end
