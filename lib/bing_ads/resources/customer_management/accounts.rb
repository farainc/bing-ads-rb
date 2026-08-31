# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerManagement
      # Account CRUD (GetAccount, SignupCustomer, UpdateAccount, DeleteAccount,
      # SearchAccounts, FindAccountsOrCustomersInfo, GetAccountsInfo, GetAccountPilotFeatures).
      class Accounts < Base
        service :customer_management

        # Gets the details of a single account (GetAccount).
        #
        # +account_id+:: Identifier of the account to get.
        # +return_additional_fields+:: Optional. Additional account properties to include in the
        #                              returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +account+ field.
        def find(account_id:, return_additional_fields: nil, **options)
          post("/Account/Query",
               { account_id: account_id, return_additional_fields: Utils.flags(return_additional_fields),
                 **options }.compact)
        end

        # Creates a new customer and account (SignupCustomer).
        #
        # +account+:: AdvertiserAccount object specifying the details of the customer's primary account.
        # +customer+:: Optional. Customer object specifying the details of the customer to add.
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
        def create(account:, customer: nil, parent_customer_id: nil, user_invitation: nil, user_id: nil,
                   user: nil, **options)
          post("/Account",
               { account: account, customer: customer, parent_customer_id: parent_customer_id,
                 user_invitation: user_invitation, user_id: user_id, user: user, **options }.compact)
        end

        # Updates the details of the specified account (UpdateAccount).
        #
        # +account+:: AdvertiserAccount object containing the updated account information.
        #             Must include the time stamp from the most recent GetAccount response.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +last_modified_time+.
        def update(account:, **options)
          put("/Account", { account: account, **options }.compact)
        end

        # Deletes an account (DeleteAccount).
        #
        # +account_id+:: Identifier of the account to delete.
        # +time_stamp+:: Time-stamp value obtained from GetAccount used to reconcile the delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an empty response body.
        def delete(account_id:, time_stamp:, **options)
          request(:delete, "/Account", { account_id: account_id, time_stamp: time_stamp, **options }.compact)
        end

        # Searches for accounts that match the request criteria (SearchAccounts).
        #
        # +predicates+:: Array of Predicate objects defining the filter conditions.
        # +page_info+:: Paging object determining the index and size of results per page.
        # +ordering+:: Optional. Array of OrderBy objects specifying the result sort order.
        # +return_additional_fields+:: Optional. Additional account properties to include in each
        #                              returned account.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +accounts+ array.
        def search(predicates:, page_info:, ordering: nil, return_additional_fields: nil, **options)
          post("/Accounts/Search",
               { predicates: predicates, page_info: page_info, ordering: ordering,
                 return_additional_fields: Utils.flags(return_additional_fields), **options }.compact)
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
        def find_by_criteria(filter: nil, top_n: nil, return_additional_fields: nil, **options)
          post("/Accounts/Find",
               { filter: filter, top_n: top_n, return_additional_fields: Utils.flags(return_additional_fields),
                 **options }.compact)
        end

        # Gets identifiers, names, and numbers of accounts accessible from the specified customer
        # (GetAccountsInfo).
        #
        # +customer_id+:: Optional. Identifier of the customer used to get account information.
        #                 If not set, the user's credentials determine the customer.
        # +only_parent_accounts+:: Optional. When true, returns only accounts directly under the
        #                          customer rather than also returning linked accounts.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +accounts_info+ array.
        def info(customer_id: nil, only_parent_accounts: nil, **options)
          post("/AccountsInfo/Query",
               { customer_id: customer_id, only_parent_accounts: only_parent_accounts, **options }.compact)
        end

        # Gets a list of feature pilot IDs enabled for an ad account (GetAccountPilotFeatures).
        #
        # +account_id+:: Optional. Identifier of the account used to get a list of feature pilot IDs.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +feature_pilot_flags+ array of integers.
        def pilot_features(account_id: nil, **options)
          post("/AccountPilotFeatures/Query", { account_id: account_id, **options }.compact)
        end
      end
    end
  end
end
