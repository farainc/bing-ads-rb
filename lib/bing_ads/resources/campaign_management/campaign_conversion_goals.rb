# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Campaign-level conversion goal associations
      # (AddCampaignConversionGoals, DeleteCampaignConversionGoals).
      class CampaignConversionGoals < Base
        service :campaign_management

        # Associates conversion goals with specific campaigns (AddCampaignConversionGoals).
        #
        # +campaign_conversion_goals+:: Array of CampaignConversionGoal objects to add;
        #                               each must contain +campaign_id+ and +goal_id+.
        # +account_id+::                Identifier of the account that contains the campaigns.
        #                               Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def create(campaign_conversion_goals:, account_id: client.account_id, **options)
          post("/CampaignConversionGoals",
               { account_id: account_id, campaign_conversion_goals: campaign_conversion_goals, **options }.compact)
        end

        # Removes conversion goal associations from campaigns (DeleteCampaignConversionGoals).
        #
        # +campaign_conversion_goals+:: Array of CampaignConversionGoal objects to delete;
        #                               each must contain +campaign_id+ and +goal_id+.
        # +account_id+::                Identifier of the account that contains the campaigns.
        #                               Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(campaign_conversion_goals:, account_id: client.account_id, **options)
          request(:delete, "/CampaignConversionGoals",
                  { account_id: account_id, campaign_conversion_goals: campaign_conversion_goals, **options }.compact)
        end
      end
    end
  end
end
