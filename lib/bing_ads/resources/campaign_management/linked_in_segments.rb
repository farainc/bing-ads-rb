# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # LinkedIn audience segment management for LinkedIn Profile targeting
      # (AddLinkedInSegments, UpdateLinkedInSegments, DeleteLinkedInSegments,
      # SearchLinkedInCompanies).
      class LinkedInSegments < Base
        service :campaign_management

        # Adds LinkedIn audience segments to the customer account
        # (AddLinkedInSegments).
        #
        # +linked_in_segments+:: Array of LinkedInSegment objects to add.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +linked_in_segment_ids+ and +partial_errors+.
        def create(linked_in_segments:, **options)
          post("/LinkedInSegments", { linked_in_segments: linked_in_segments, **options }.compact)
        end

        # Updates LinkedIn audience segments (UpdateLinkedInSegments).
        #
        # +linked_in_segments+:: Array of LinkedInSegment objects to update;
        #                        each must include its +id+.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(linked_in_segments:, **options)
          put("/LinkedInSegments", { linked_in_segments: linked_in_segments, **options }.compact)
        end

        # Deletes LinkedIn audience segments (DeleteLinkedInSegments).
        #
        # +linked_in_segment_ids+:: Array of LinkedIn segment identifiers to delete.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(linked_in_segment_ids:, **options)
          request(:delete, "/LinkedInSegments",
                  { linked_in_segment_ids: linked_in_segment_ids, **options }.compact)
        end

        # Searches for LinkedIn companies by name (SearchLinkedInCompanies).
        #
        # +company_name_filter+:: Optional. Company name string to filter results by.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with a +companies+ array.
        def search_companies(**options)
          post("/Companies/Search", options)
        end
      end
    end
  end
end
