# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerBilling
      # Insertion order management (AddInsertionOrder, UpdateInsertionOrder, SearchInsertionOrders).
      class InsertionOrders < Base
        service :customer_billing

        # Adds an insertion order to the specified account (AddInsertionOrder).
        #
        # +insertion_order+:: InsertionOrder object to add to the account.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +insertion_order_id+ and +create_time+.
        def create(insertion_order:, **options)
          post("/InsertionOrder", { insertion_order: insertion_order, **options }.compact)
        end

        # Updates an insertion order within the specified account (UpdateInsertionOrder).
        #
        # +insertion_order+:: InsertionOrder object with updated fields.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +last_modified_time+.
        def update(insertion_order:, **options)
          put("/InsertionOrder", { insertion_order: insertion_order, **options }.compact)
        end

        # Searches for insertion orders that match specified criteria (SearchInsertionOrders).
        #
        # +predicates+:: Array of Predicate objects (up to 6); one must have field AccountId.
        # +page_info+:: Paging object specifying index and page size.
        # +ordering+:: Optional. Array of OrderBy objects determining sort order (only first element is used).
        # +return_additional_fields+:: Optional. Additional InsertionOrder properties to include in each result.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with an +insertion_orders+ array.
        def search(predicates:, page_info:, ordering: nil, return_additional_fields: nil, **options)
          post("/InsertionOrders/Search",
               { predicates: predicates, ordering: ordering, page_info: page_info,
                 return_additional_fields: return_additional_fields, **options }.compact)
        end
      end
    end
  end
end
