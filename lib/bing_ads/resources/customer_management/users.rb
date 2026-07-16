# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerManagement
      # User CRUD (GetUser, UpdateUser, DeleteUser, UpdateUserRoles,
      # GetUserMFAStatus, GetUsersInfo).
      class Users < Base
        service :customer_management

        # Gets the details of a user (GetUser).
        #
        # +user_id+:: Optional. Identifier of the user to get. Pass +nil+ (default) to fetch
        #             the authenticated user specified in the request header.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +user+ and +customer_roles+.
        def find(user_id: nil, **options)
          post("/User/Query", { user_id: user_id, **options })
        end

        alias me find

        # Updates the personal and business contact information about a user (UpdateUser).
        #
        # +user+:: User object containing the updated user information.
        #          Must include the time stamp from the most recent GetUser response.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +last_modified_time+.
        def update(user:, **options)
          put("/User", { user: user, **options }.compact)
        end

        # Deletes a user (DeleteUser).
        #
        # +user_id+:: Identifier of the user to delete.
        # +time_stamp+:: Time-stamp value obtained from GetUser used to reconcile the delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an empty response body.
        def delete(user_id:, time_stamp:, **options)
          request(:delete, "/User", { user_id: user_id, time_stamp: time_stamp, **options }.compact)
        end

        # Updates the roles of the specified user (UpdateUserRoles).
        #
        # +customer_id+:: Identifier of the customer to which the user belongs.
        # +user_id+:: Optional. Identifier of the user whose role you want to update.
        # +new_role_id+:: Optional. Identifier of the role to assign via +new_account_ids+ or
        #                 +new_customer_ids+.
        # +new_account_ids+:: Optional. Array of account identifiers to add to the user's access.
        # +new_customer_ids+:: Optional. Array of customer identifiers to add to the user's access.
        # +delete_role_id+:: Optional. Identifier of the role to remove via +delete_account_ids+ or
        #                    +delete_customer_ids+.
        # +delete_account_ids+:: Optional. Array of account identifiers to remove from the user's access.
        # +delete_customer_ids+:: Optional. Array of customer identifiers to remove from the user's access.
        #
        # Returns an object with +last_modified_time+.
        def update_roles(customer_id:, user_id: nil, new_role_id: nil, new_account_ids: nil,
                         new_customer_ids: nil, delete_role_id: nil, delete_account_ids: nil,
                         delete_customer_ids: nil, **options)
          put("/UserRoles",
              { customer_id: customer_id, user_id: user_id, new_role_id: new_role_id,
                new_account_ids: new_account_ids, new_customer_ids: new_customer_ids,
                delete_role_id: delete_role_id, delete_account_ids: delete_account_ids,
                delete_customer_ids: delete_customer_ids, **options }.compact)
        end

        # Gets the MFA status of a user (GetUserMFAStatus — no confirmed public docs URL).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with MFA status information.
        def mfa_status(**options)
          post("/UserMFAStatus/Query", options)
        end

        # Gets a list of user identification objects for users belonging to a customer
        # (GetUsersInfo).
        #
        # +customer_id+:: Optional. Identifier of the customer to which the users belong.
        # +status_filter+:: Optional. UserLifeCycleStatus value to filter the list of users returned.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +users_info+ array.
        def info(customer_id: nil, status_filter: nil, **options)
          post("/UsersInfo/Query", { customer_id: customer_id, status_filter: status_filter, **options }.compact)
        end
      end
    end
  end
end
