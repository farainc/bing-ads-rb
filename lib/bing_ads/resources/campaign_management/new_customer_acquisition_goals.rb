# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # New Customer Acquisition goal CRUD
      # (AddNewCustomerAcquisitionGoals, GetNewCustomerAcquisitionGoalsByAccountId,
      # UpdateNewCustomerAcquisitionGoals).
      class NewCustomerAcquisitionGoals < Base
        service :campaign_management

        # Adds new customer acquisition goals for the customer
        # (AddNewCustomerAcquisitionGoals).
        #
        # +new_customer_acquisition_goals+:: Array of NewCustomerAcquisitionGoal objects
        #                                    to add.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +new_customer_acquisition_goal_ids+ and +partial_errors+.
        def create(new_customer_acquisition_goals:, **options)
          post("/NewCustomerAcquisitionGoals",
               { new_customer_acquisition_goals: new_customer_acquisition_goals, **options }.compact)
        end

        # Gets all new customer acquisition goals for an account
        # (GetNewCustomerAcquisitionGoalsByAccountId).
        #
        # +account_id+:: Identifier of the account to query.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +new_customer_acquisition_goals+.
        def list(account_id: client.account_id, **options)
          post("/NewCustomerAcquisitionGoals/QueryByAccountId",
               { account_id: account_id, **options }.compact)
        end

        # Updates new customer acquisition goals (UpdateNewCustomerAcquisitionGoals).
        #
        # +new_customer_acquisition_goals+:: Array of NewCustomerAcquisitionGoal objects
        #                                    to update; each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(new_customer_acquisition_goals:, **options)
          put("/NewCustomerAcquisitionGoals",
              { new_customer_acquisition_goals: new_customer_acquisition_goals, **options }.compact)
        end
      end
    end
  end
end
