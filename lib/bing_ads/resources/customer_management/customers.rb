# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerManagement
      # Customer CRUD (GetCustomer, SignupCustomer, UpdateCustomer, DeleteCustomer,
      # SearchCustomers, GetCustomersInfo, GetCustomerPilotFeatures,
      # GetLinkedAccountsAndCustomersInfo, FindAccountsOrCustomersInfo, ValidateAddress).
      class Customers < Base
        service :customer_management

        # Gets the details of a customer (GetCustomer).
        #
        # +customer_id+:: Optional. Identifier of the customer whose information you want to get.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +customer+ field.
        def find(customer_id: nil, **options)
          post("/Customer/Query", { customer_id: customer_id, **options })
        end

        # Creates a new customer and account (SignupCustomer).
        #
        # +customer+:: Customer object specifying the details of the customer to add.
        # +account+:: Optional. AdvertiserAccount object specifying the details of the customer's primary account.
        # +parent_customer_id+:: Optional. Identifier of the aggregator or agency that will manage the
        #                        new child customer.
        # +user_invitation+:: Optional. UserInvitation to send when signing up on behalf of a client.
        # +user_id+:: Optional. Identifier of an existing user to add as Super Admin in the new customer.
        # +user+:: Optional. User object to create as a new admin user simultaneously with signup.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +customer_id+, +customer_number+, +account_id+, +account_number+,
        # and +create_time+.
        def signup(customer:, account: nil, parent_customer_id: nil, user_invitation: nil, user_id: nil,
                   user: nil, **options)
          post("/Customer/Signup",
               { customer: customer, account: account, parent_customer_id: parent_customer_id,
                 user_invitation: user_invitation, user_id: user_id, user: user, **options }.compact)
        end

        # Updates the details of the specified customer (UpdateCustomer).
        #
        # +customer+:: Customer object containing the updated customer information.
        #              Must include the time stamp from the most recent GetCustomer response.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +last_modified_time+.
        def update(customer:, **options)
          put("/Customer", { customer: customer, **options }.compact)
        end

        # Deletes a customer (DeleteCustomer).
        #
        # +customer_id+:: Identifier of the customer to delete.
        # +time_stamp+:: Time-stamp value obtained from GetCustomer used to reconcile the delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an empty response body.
        def delete(customer_id:, time_stamp:, **options)
          request(:delete, "/Customer", { customer_id: customer_id, time_stamp: time_stamp, **options }.compact)
        end

        # Searches for customers that match the request criteria (SearchCustomers).
        #
        # +predicates+:: Array of Predicate objects defining the filter conditions (1 to 10 predicates).
        # +page_info+:: Paging object determining the index and size of results per page.
        # +date_range+:: Optional. DateRange object specifying minimum and maximum customer creation dates.
        # +ordering+:: Optional. Array of OrderBy objects specifying the result sort order.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +customers+ array.
        def search(predicates:, page_info:, date_range: nil, ordering: nil, **options)
          post("/Customers/Search",
               { predicates: predicates, page_info: page_info, date_range: date_range,
                 ordering: ordering, **options }.compact)
        end

        # Gets identifiers and names of customers accessible to the authenticated user
        # (GetCustomersInfo).
        #
        # +customer_name_filter+:: Optional. Partial or full customer name to filter by.
        # +top_n+:: Optional. Number of customers to return in the result.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +customers_info+ array.
        def info(customer_name_filter: nil, top_n: nil, **options)
          post("/CustomersInfo/Query",
               { customer_name_filter: customer_name_filter, top_n: top_n, **options }.compact)
        end

        # Gets a list of feature pilot IDs enabled for all ad accounts owned by a customer
        # (GetCustomerPilotFeatures).
        #
        # +customer_id+:: Identifier of the customer used to get a list of feature pilot IDs.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +feature_pilot_flags+ array of integers.
        def pilot_features(customer_id:, **options)
          post("/CustomerPilotFeatures/Query", { customer_id: customer_id, **options }.compact)
        end

        # Gets the customer and account hierarchy under the specified customer
        # (GetLinkedAccountsAndCustomersInfo).
        #
        # +customer_id+:: Optional. Identifier of the customer whose hierarchy you want to get.
        # +only_parent_accounts+:: Optional. When true, returns only accounts directly under the
        #                          customer rather than also returning linked customers and accounts.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +accounts_info+ and +customers_info+ arrays.
        def linked_accounts_and_customers_info(customer_id: nil, only_parent_accounts: nil, **options)
          post("/LinkedAccountsAndCustomersInfo/Query",
               { customer_id: customer_id, only_parent_accounts: only_parent_accounts, **options }.compact)
        end

        # Gets a list of accounts and customers matching the specified filter criteria
        # (FindAccountsOrCustomersInfo).
        #
        # +filter+:: Optional. Partial or full account name, account number, or customer name to match.
        # +top_n+:: Optional. Number of accounts to return in the result (1 through 5,000).
        # +return_additional_fields+:: Optional. Additional account properties to include in each
        #                              returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +account_info_with_customer_data+ array.
        def find_accounts_or_customers_info(filter: nil, top_n: nil, return_additional_fields: nil, **options)
          post("/AccountsOrCustomersInfo/Find",
               { filter: filter, top_n: top_n, return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Determines whether the submitted address is valid for Microsoft Advertising accounts
        # (ValidateAddress).
        #
        # +address+:: Optional. Address object to validate.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +original_address+, +status+, and +suggested_addresses+.
        def validate_address(address: nil, **options)
          post("/Address/Validate", { address: address, **options }.compact)
        end
      end
    end
  end
end
