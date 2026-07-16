# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Campaign CRUD (AddCampaigns, GetCampaignsByAccountId, GetCampaignsByIds,
      # UpdateCampaigns, DeleteCampaigns).
      class Campaigns < Base
        service :campaign_management

        # Adds new campaigns to the account (AddCampaigns).
        #
        # +campaigns+:: Array of Campaign objects to add (maximum 100 per call).
        # +account_id+:: Identifier of the account to add the campaigns to.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +campaign_ids+ and +partial_errors+.
        def create(campaigns:, account_id: client.account_id, **options)
          post("/Campaigns", { account_id: account_id, campaigns: campaigns, **options }.compact)
        end

        # Gets all campaigns in the account (GetCampaignsByAccountId).
        #
        # +account_id+:: Identifier of the account that contains the campaigns.
        #                Defaults to the client's +account_id+.
        # +campaign_type+:: Optional. Campaign types to return, e.g.
        #                   <tt>"Search Shopping DynamicSearchAds"</tt>.
        # +return_additional_fields+:: Optional. Additional Campaign properties to
        #                              include in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +campaigns+ array.
        def list(account_id: client.account_id, campaign_type: nil, return_additional_fields: nil, **options)
          post("/Campaigns/QueryByAccountId",
               { account_id: account_id, campaign_type: campaign_type,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Gets campaigns by their identifiers (GetCampaignsByIds).
        #
        # +campaign_ids+:: Array of campaign identifiers (maximum 100 per call).
        # +account_id+:: Identifier of the account that contains the campaigns.
        #                Defaults to the client's +account_id+.
        # +campaign_type+:: Optional. Campaign types to return, e.g.
        #                   <tt>"Search Shopping DynamicSearchAds"</tt>.
        # +return_additional_fields+:: Optional. Additional Campaign properties to
        #                              include in each returned object.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +campaigns+ and +partial_errors+.
        def find(campaign_ids:, account_id: client.account_id, campaign_type: nil,
                 return_additional_fields: nil, **options)
          post("/Campaigns/QueryByIds",
               { account_id: account_id, campaign_ids: campaign_ids, campaign_type: campaign_type,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end

        # Updates existing campaigns (UpdateCampaigns).
        #
        # +campaigns+:: Array of Campaign objects to update (maximum 100 per call);
        #               each must include its +id+.
        # +account_id+:: Identifier of the account that contains the campaigns.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(campaigns:, account_id: client.account_id, **options)
          put("/Campaigns", { account_id: account_id, campaigns: campaigns, **options }.compact)
        end

        # Deletes campaigns (DeleteCampaigns).
        #
        # +campaign_ids+:: Array of identifiers of the campaigns to delete
        #                  (maximum 100 per call).
        # +account_id+:: Identifier of the account that contains the campaigns.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(campaign_ids:, account_id: client.account_id, **options)
          request(:delete, "/Campaigns",
                  { account_id: account_id, campaign_ids: campaign_ids, **options }.compact)
        end
      end
    end
  end
end
