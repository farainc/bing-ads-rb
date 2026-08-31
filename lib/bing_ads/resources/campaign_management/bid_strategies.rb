# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Portfolio bid-strategy CRUD (AddBidStrategies, GetBidStrategiesByIds,
      # UpdateBidStrategies, DeleteBidStrategies).
      class BidStrategies < Base
        service :campaign_management

        # Adds bid strategies to the account's portfolio bid strategy library
        # (AddBidStrategies).
        #
        # +bid_strategies+:: Array of BidStrategy objects to add (maximum 100 per call).
        # +account_id+::     Identifier of the account that owns the bid strategies.
        #                    Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +bid_strategy_ids+ and +partial_errors+.
        def create(bid_strategies:, account_id: client.account_id, **options)
          post("/BidStrategies",
               { account_id: account_id, bid_strategies: bid_strategies, **options }.compact)
        end

        # Gets bid strategies from the account's portfolio bid strategy library
        # (GetBidStrategiesByIds).
        #
        # +bid_strategy_ids+::         Array of bid strategy identifiers (maximum 100). If nil or
        #                              empty, all portfolio bid strategies in the account are returned.
        # +account_id+::               Identifier of the account that owns the bid strategies.
        #                              Defaults to the client's +account_id+.
        # +return_additional_fields+:: Optional. Additional BidStrategy properties to include.
        # +scope+::                    Optional. EntityScope to filter by (+Account+ or +Customer+).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +bid_strategies+ and +partial_errors+.
        def find(bid_strategy_ids:, account_id: client.account_id,
                 return_additional_fields: nil, scope: nil, **options)
          post("/BidStrategies/QueryByIds",
               { account_id: account_id, bid_strategy_ids: bid_strategy_ids,
                 return_additional_fields: Utils.flags(return_additional_fields), scope: scope, **options }.compact)
        end

        # Updates bid strategies in the account's portfolio bid strategy library
        # (UpdateBidStrategies).
        #
        # +bid_strategies+:: Array of BidStrategy objects to update (maximum 100 per call);
        #                    each must include its +id+.
        # +account_id+::     Identifier of the account that owns the bid strategies.
        #                    Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(bid_strategies:, account_id: client.account_id, **options)
          put("/BidStrategies",
              { account_id: account_id, bid_strategies: bid_strategies, **options }.compact)
        end

        # Deletes bid strategies from the account's portfolio bid strategy library
        # (DeleteBidStrategies).
        #
        # +bid_strategy_ids+:: Array of bid strategy identifiers to delete (maximum 100 per call).
        # +account_id+::       Identifier of the account that owns the bid strategies.
        #                      Defaults to the client's +account_id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(bid_strategy_ids:, account_id: client.account_id, **options)
          request(:delete, "/BidStrategies",
                  { account_id: account_id, bid_strategy_ids: bid_strategy_ids, **options }.compact)
        end
      end
    end
  end
end
