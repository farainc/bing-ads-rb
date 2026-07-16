# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerManagement
      # User invitation management (SendUserInvitation, SearchUserInvitations).
      class UserInvitations < Base
        service :customer_management

        # Sends an email invitation for a user to sign up for Microsoft Advertising
        # (SendUserInvitation).
        #
        # +user_invitation+:: UserInvitation object specifying the invitation details.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +user_invitation_id+.
        def create(user_invitation:, **options)
          post("/UserInvitation/Send", { user_invitation: user_invitation, **options }.compact)
        end

        # Searches for user invitations that match the request criteria (SearchUserInvitations).
        #
        # +predicates+:: Array of Predicate objects defining the filter conditions (exactly 1 predicate).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +user_invitations+ array.
        def search(predicates:, **options)
          post("/UserInvitations/Search", { predicates: predicates, **options }.compact)
        end
      end
    end
  end
end
