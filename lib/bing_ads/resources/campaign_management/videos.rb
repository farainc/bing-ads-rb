# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # Video CRUD for Microsoft Advertising Campaign Management.
      class Videos < Base
        service :campaign_management

        # Adds one or more videos to the account (AddVideos).
        #
        # +videos+:: Array of Video objects to add (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +video_ids+ and +partial_errors+.
        def create(videos:, **options)
          post("/Videos", { videos: videos, **options }.compact)
        end

        # Retrieves videos by their identifiers (GetVideosByIds).
        #
        # +video_ids+:: Optional. Array of video identifiers to retrieve.
        #               When omitted, returns all videos in the account.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an array of Video objects.
        def find(video_ids: nil, **options)
          post("/Videos/QueryByIds", { video_ids: video_ids, **options }.compact)
        end

        # Updates one or more videos within the account (UpdateVideos).
        #
        # +videos+:: Array of Video objects to update (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def update(videos:, **options)
          put("/Videos", { videos: videos, **options }.compact)
        end

        # Deletes one or more videos from the account (DeleteVideos).
        #
        # +video_ids+:: Array of video identifiers to delete (maximum 100 per call).
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +partial_errors+.
        def delete(video_ids:, **options)
          request(:delete, "/Videos", { video_ids: video_ids, **options }.compact)
        end
      end
    end
  end
end
