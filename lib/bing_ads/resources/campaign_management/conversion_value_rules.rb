# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Conversion value rule CRUD
      # (AddConversionValueRules, GetConversionValueRulesByAccountId,
      # GetConversionValueRulesByIds, UpdateConversionValueRules,
      # UpdateConversionValueRulesStatus).
      class ConversionValueRules < Base
        service :campaign_management

        # Adds conversion value rules to the account (AddConversionValueRules).
        #
        # +conversion_value_rules+:: Array of ConversionValueRule objects to add.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +conversion_value_rule_ids+ and +partial_errors+.
        def create(conversion_value_rules:, **options)
          post("/ConversionValueRules", { conversion_value_rules: conversion_value_rules, **options }.compact)
        end

        # Gets conversion value rules by their identifiers (GetConversionValueRulesByIds).
        #
        # +conversion_value_rule_ids+:: Array of conversion value rule identifiers to retrieve.
        # +account_id+::                Identifier of the account that contains the rules.
        #                               Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +conversion_value_rules+ and +partial_errors+.
        def find(conversion_value_rule_ids:, account_id: client.account_id, **options)
          post("/ConversionValueRules/QueryByIds",
               { account_id: account_id, conversion_value_rule_ids: conversion_value_rule_ids, **options }.compact)
        end

        # Gets all conversion value rules for an account
        # (GetConversionValueRulesByAccountId).
        #
        # +account_id+:: Identifier of the account to query.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +conversion_value_rules+.
        def list(account_id: client.account_id, **options)
          post("/ConversionValueRules/QueryByAccountId", { account_id: account_id, **options }.compact)
        end

        # Updates conversion value rules (UpdateConversionValueRules).
        #
        # +conversion_value_rules+:: Array of ConversionValueRule objects to update;
        #                            each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(conversion_value_rules:, **options)
          put("/ConversionValueRules", { conversion_value_rules: conversion_value_rules, **options }.compact)
        end

        # Updates the status of conversion value rules (UpdateConversionValueRulesStatus).
        #
        # +conversion_value_rule_ids+:: Array of conversion value rule identifiers.
        # +status+::                    Target status string, e.g.
        #                               <tt>"Active"</tt> or <tt>"Paused"</tt>.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update_status(conversion_value_rule_ids:, status:, **options)
          put("/ConversionValueRulesStatus",
              { conversion_value_rule_ids: conversion_value_rule_ids, status: status, **options }.compact)
        end
      end
    end
  end
end
