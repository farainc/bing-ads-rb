# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Budget CRUD plus campaign-ID lookup (AddBudgets, GetBudgetsByIds, UpdateBudgets,
      # DeleteBudgets, GetCampaignIdsByBudgetIds).
      class Budgets < Base
        service :campaign_management

        # Adds new budgets to the account's shared budget library (AddBudgets).
        #
        # +budgets+:: Array of Budget objects to add (maximum 100 per call). Each object
        #             may include +amount+, +association_count+, +budget_type+, +id+,
        #             and +name+.
        # +account_id+:: Identifier of the account to add the budgets to.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +budget_ids+ and +partial_errors+.
        def create(budgets:, account_id: client.account_id, **options)
          post("/Budgets", { account_id: account_id, budgets: budgets, **options }.compact)
        end

        # Gets the specified budgets from the account's shared budget library (GetBudgetsByIds).
        #
        # +budget_ids+:: Array of budget identifiers to retrieve (maximum 100 per call).
        #                If nil or empty, all shared budgets in the account are returned.
        # +account_id+:: Identifier of the account that owns the budgets.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +budgets+ and +partial_errors+.
        def find(budget_ids:, account_id: client.account_id, **options)
          post("/Budgets/QueryByIds", { account_id: account_id, budget_ids: budget_ids, **options }.compact)
        end

        # Updates existing budgets in the account's shared budget library (UpdateBudgets).
        #
        # +budgets+:: Array of Budget objects to update (maximum 100 per call); each must
        #             include its +id+. Updatable fields: +amount+, +association_count+,
        #             +budget_type+, +name+.
        # +account_id+:: Identifier of the account that contains the budgets.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(budgets:, account_id: client.account_id, **options)
          put("/Budgets", { account_id: account_id, budgets: budgets, **options }.compact)
        end

        # Deletes budgets from the account's shared budget library (DeleteBudgets).
        #
        # +budget_ids+:: Array of budget identifiers to delete (maximum 100 per call).
        # +account_id+:: Identifier of the account that contains the budgets.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(budget_ids:, account_id: client.account_id, **options)
          request(:delete, "/Budgets", { account_id: account_id, budget_ids: budget_ids, **options }.compact)
        end

        # Gets campaign identifiers that share each specified budget (GetCampaignIdsByBudgetIds).
        #
        # +budget_ids+:: Array of budget identifiers whose campaign associations to retrieve
        #                (maximum 100 per call; each budget may be shared by up to 10,000
        #                campaigns).
        # +account_id+:: Identifier of the account that contains the budgets.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +campaign_id_collection+ and +partial_errors+.
        def campaign_ids_by_budget_ids(budget_ids:, account_id: client.account_id, **options)
          post("/CampaignIds/QueryByBudgetIds", { account_id: account_id, budget_ids: budget_ids, **options }.compact)
        end
      end
    end
  end
end
