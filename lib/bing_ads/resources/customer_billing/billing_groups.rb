# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerBilling
      # Billing group management (list, ungrouped_accounts, update_accounts) — internal APIs.
      class BillingGroups < Base
        service :customer_billing

        # Lists billing groups for the customer (internal API — request body fields are not publicly documented).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns the API response.
        def list(**options)
          post("/BillingGroups/Query", options)
        end

        # Lists accounts not assigned to any billing group (internal API — request body fields are not publicly
        # documented).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns the API response.
        def ungrouped_accounts(**options)
          post("/UngroupedAccounts/Query", options)
        end

        # Updates the accounts associated with a billing group (internal API — request body fields are not publicly
        # documented).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns the API response.
        def update_accounts(**options)
          put("/BillingGroupAccounts", options)
        end
      end
    end
  end
end
