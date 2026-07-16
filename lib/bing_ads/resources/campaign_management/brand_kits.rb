# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Brand kit management (AddBrandKits, GetBrandKitsByIds, GetBrandKitsByAccountId,
      # UpdateBrandKits, DeleteBrandKits).
      class BrandKits < Base
        service :campaign_management

        # Creates new brand kits for the account (AddBrandKits).
        #
        # +brand_kits+:: Array of BrandKit objects to create.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +brand_kit_ids+ and +partial_errors+.
        def create(brand_kits:, **options)
          post("/BrandKits", { brand_kits: brand_kits, **options }.compact)
        end

        # Retrieves brand kits by their identifiers (GetBrandKitsByIds).
        #
        # +brand_kit_ids+:: Array of brand kit identifiers to retrieve.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +brand_kits+ and +partial_errors+.
        def find(brand_kit_ids:, **options)
          post("/BrandKits/QueryByIds", { brand_kit_ids: brand_kit_ids, **options }.compact)
        end

        # Retrieves all brand kits associated with the account (GetBrandKitsByAccountId).
        #
        # +account_id+:: Identifier of the account to retrieve brand kits for.
        #                Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +brand_kits+.
        def list(account_id: client.account_id, **options)
          post("/BrandKits/QueryByAccountId", { account_id: account_id, **options }.compact)
        end

        # Updates brand kits in the account (UpdateBrandKits).
        #
        # +brand_kits+:: Array of BrandKit objects to update (each must include +id+).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(brand_kits:, **options)
          put("/BrandKits", { brand_kits: brand_kits, **options }.compact)
        end

        # Deletes brand kits from the account (DeleteBrandKits).
        #
        # +brand_kit_ids+:: Array of brand kit identifiers to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(brand_kit_ids:, **options)
          request(:delete, "/BrandKits", { brand_kit_ids: brand_kit_ids, **options }.compact)
        end
      end
    end
  end
end
