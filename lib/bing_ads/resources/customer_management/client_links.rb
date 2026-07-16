# frozen_string_literal: true

module BingAds
  module Resources
    module CustomerManagement
      # Client link management (AddClientLinks, UpdateClientLinks, SearchClientLinks).
      class ClientLinks < Base
        service :customer_management

        # Initiates the client link process to manage accounts of another customer
        # (AddClientLinks).
        #
        # +client_links+:: Array of ClientLink objects to add (maximum 10 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +operation_errors+ and +partial_errors+.
        def create(client_links:, **options)
          post("/ClientLinks", { client_links: client_links, **options }.compact)
        end

        # Updates the status of the specified client links (UpdateClientLinks).
        #
        # +client_links+:: Array of ClientLink objects to update (maximum 10 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +operation_errors+ and +partial_errors+.
        def update(client_links:, **options)
          put("/ClientLinks", { client_links: client_links, **options }.compact)
        end

        # Searches for client links filtered by the search criteria (SearchClientLinks).
        #
        # +predicates+:: Array of Predicate objects defining the filter conditions (1 to 2 predicates).
        # +page_info+:: Paging object determining the index and size of results per page.
        # +ordering+:: Optional. Array of OrderBy objects specifying the result sort order.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +client_links+ array.
        def search(predicates:, page_info:, ordering: nil, **options)
          post("/ClientLinks/Search",
               { predicates: predicates, page_info: page_info, ordering: ordering, **options }.compact)
        end
      end
    end
  end
end
