# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # HTML5 ad CRUD for Microsoft Advertising Campaign Management.
      class HTML5s < Base
        service :campaign_management

        # Adds one or more HTML5 ads to the account (AddHTML5Ads).
        #
        # +html5s+:: Array of HTML5 ad objects to add.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +html5_ids+ and +partial_errors+.
        def create(html5s:, **options)
          post("/HTML5s", { html5s: html5s, **options }.compact)
        end

        # Retrieves HTML5 ads by their identifiers (GetHTML5AdsByIds).
        #
        # +html5_ids+:: Optional. Array of HTML5 ad identifiers to retrieve.
        #               When omitted, returns all HTML5 ads in the account.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an array of HTML5 ad objects.
        def find(html5_ids: nil, **options)
          post("/HTML5s/QueryByIds", { html5_ids: html5_ids, **options }.compact)
        end

        # Deletes one or more HTML5 ads from the account (DeleteHTML5Ads).
        #
        # +html5_ids+:: Array of HTML5 ad identifiers to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(html5_ids:, **options)
          request(:delete, "/HTML5s", { html5_ids: html5_ids, **options }.compact)
        end
      end
    end
  end
end
