# frozen_string_literal: true

require "test_helper"

class TestCustomerManagementResources < Minitest::Test
  include ResourceTestHelper

  CC = "https://clientcenter.api.bingads.microsoft.com/CustomerManagement/v13"

  def assert_ops(resource, ops)
    ops.each do |method, (verb, path, args, body)|
      stub = stub_op(verb, "#{CC}/#{path}", body)
      sdk_client.customer_management.public_send(resource).public_send(method, **args)
      assert_requested stub
    end
  end

  def test_users_me
    stub = stub_op(:post, "#{CC}/User/Query", { "UserId" => nil })
    sdk_client.customer_management.users.me
    assert_requested stub
  end

  def test_users_operations
    assert_ops(:users,
               update: [:put, "User", { user: { "Id" => 1 } }, { "User" => { "Id" => 1 } }],
               delete: [:delete, "User", { user_id: 1, time_stamp: "ts" }, { "UserId" => 1, "TimeStamp" => "ts" }],
               update_roles: [:put, "UserRoles", { customer_id: 2 }, { "CustomerId" => 2 }],
               mfa_status: [:post, "UserMFAStatus/Query", {}, {}],
               info: [:post, "UsersInfo/Query", {}, {}])
  end

  def test_accounts_operations
    assert_ops(:accounts,
               find: [:post, "Account/Query", { account_id: 456 }, { "AccountId" => 456 }],
               create: [:post, "Account", { account: { "Name" => "A" } },
                        { "Account" => { "Name" => "A" } }],
               update: [:put, "Account", { account: { "Id" => 456 } },
                        { "Account" => { "Id" => 456 } }],
               delete: [:delete, "Account", { account_id: 456, time_stamp: "ts" },
                        { "AccountId" => 456, "TimeStamp" => "ts" }],
               search: [:post, "Accounts/Search",
                        { predicates: [], page_info: { "Index" => 0, "Size" => 10 } },
                        { "Predicates" => [], "PageInfo" => { "Index" => 0, "Size" => 10 } }],
               find_by_criteria: [:post, "Accounts/Find", {}, {}],
               info: [:post, "AccountsInfo/Query", {}, {}],
               pilot_features: [:post, "AccountPilotFeatures/Query", {}, {}])
  end

  def test_customers_operations
    assert_ops(:customers,
               signup: [:post, "Customer/Signup", { customer: { "Name" => "C" } },
                        { "Customer" => { "Name" => "C" } }],
               update: [:put, "Customer", { customer: { "Id" => 3 } }, { "Customer" => { "Id" => 3 } }],
               delete: [:delete, "Customer", { customer_id: 3, time_stamp: "ts" },
                        { "CustomerId" => 3, "TimeStamp" => "ts" }],
               search: [:post, "Customers/Search",
                        { predicates: [], page_info: { "Index" => 0, "Size" => 10 } },
                        { "Predicates" => [], "PageInfo" => { "Index" => 0, "Size" => 10 } }],
               info: [:post, "CustomersInfo/Query", {}, {}],
               pilot_features: [:post, "CustomerPilotFeatures/Query", { customer_id: 3 },
                                { "CustomerId" => 3 }],
               linked_accounts_and_customers_info: [:post, "LinkedAccountsAndCustomersInfo/Query",
                                                    {}, {}],
               find_accounts_or_customers_info: [:post, "AccountsOrCustomersInfo/Find", {}, {}],
               validate_address: [:post, "Address/Validate", {}, {}])
  end

  def test_customers_find_includes_nil_customer_id
    stub = stub_op(:post, "#{CC}/Customer/Query", { "CustomerId" => nil })
    sdk_client.customer_management.customers.find
    assert_requested stub
  end

  def test_client_links
    links = [{ "Type" => "AccountLink" }]
    paging = { "Index" => 0, "Size" => 10 }
    assert_ops(:client_links,
               create: [:post, "ClientLinks", { client_links: links }, { "ClientLinks" => links }],
               update: [:put, "ClientLinks", { client_links: links }, { "ClientLinks" => links }],
               search: [:post, "ClientLinks/Search",
                        { predicates: links, page_info: paging },
                        { "Predicates" => links, "PageInfo" => paging }])
  end

  def test_user_invitations
    invitation = { "Email" => "a@b.c" }
    stub = stub_op(:post, "#{CC}/UserInvitation/Send", { "UserInvitation" => invitation })
    sdk_client.customer_management.user_invitations.create(user_invitation: invitation)
    assert_requested stub

    predicates = [{ "Field" => "CustomerId", "Operator" => "Equals", "Value" => "123" }]
    stub = stub_op(:post, "#{CC}/UserInvitations/Search", { "Predicates" => predicates })
    sdk_client.customer_management.user_invitations.search(predicates: predicates)
    assert_requested stub
  end

  def test_notifications
    stub = stub_op(:post, "#{CC}/Notifications/Query", {})
    sdk_client.customer_management.notifications.list
    assert_requested stub

    stub = stub_op(:post, "#{CC}/Notifications/Dismiss", { "NotificationIds" => [1] })
    sdk_client.customer_management.notifications.dismiss(notification_ids: [1])
    assert_requested stub
  end
end
