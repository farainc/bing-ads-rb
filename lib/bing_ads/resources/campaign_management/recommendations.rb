# frozen_string_literal: true

module BingAds
  module Resources
    module CampaignManagement
      # AI-powered recommendation endpoints for generating and refining ad assets
      # (asset groups, responsive ads, responsive search ads, and brand kits).
      class Recommendations < Base
        service :campaign_management

        # Generates recommended asset-group assets from one or more landing-page URLs
        # (CreateAssetGroupRecommendation).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields: +FinalUrls+ (required, array of landing-page URLs), +Prompt+
        # (optional description), +TextTone+ (optional AdRecommendationTextTone),
        # +ReturnAdditionalFields+ (optional AdRecommendationAdditionalField).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +asset_group+, +image_suggestions+, and
        # +prompt_brand_warning+.
        def create_asset_group_recommendation(**options)
          post("/AssetGroupRecommendation/Create", { **options }.compact)
        end

        # Refines a previously generated asset-group recommendation
        # (RefineAssetGroupRecommendation).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields: +AssetGroup+ (required, AssetGroup object),
        # +ImageRefineOperations+ (array of AdRecommendationImageRefineOperation),
        # +ImageSuggestions+ (reserved), +TextRefineOperations+ (reserved),
        # +ReturnAdditionalFields+ (reserved).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +text_refine_results+ and +media_refine_results+.
        def refine_asset_group_recommendation(**options)
          post("/AssetGroupRecommendation/Refine", { **options }.compact)
        end

        # Generates a brand kit from a landing-page URL (CreateBrandKitRecommendation).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields: +AccountId+ (required, long), +FinalUrl+ (required, landing-page URL).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +brand_kit+.
        def create_brand_kit_recommendation(**options)
          post("/BrandKitRecommendation/Create", { **options }.compact)
        end

        # Generates recommended responsive-ad assets from one or more landing-page URLs
        # (CreateResponsiveAdRecommendation).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields: +FinalUrls+ (required, array of URLs), +VideoType+ (required,
        # AdRecommendationVideoType — CTV or OLV), +AdSubType+ (optional),
        # +BrandKitId+ (optional, long), +Prompt+ (optional), +TextTone+ (optional),
        # +ReturnAdditionalFields+ (optional).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +responsive_ad+, +image_suggestions+,
        # +video_suggestions+, +prompt_brand_warning+, and +job_info+.
        def create_responsive_ad_recommendation(**options)
          post("/ResponsiveAdRecommendation/Create", { **options }.compact)
        end

        # Refines a previously generated responsive-ad recommendation
        # (RefineResponsiveAdRecommendation).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields: +ResponsiveAd+ (reserved), +TextRefineOperations+ (reserved),
        # +ImageRefineOperations+ (reserved), +ImageSuggestions+ (reserved),
        # +ReturnAdditionalFields+ (reserved).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +text_refine_results+ and +media_refine_results+.
        def refine_responsive_ad_recommendation(**options)
          post("/ResponsiveAdRecommendation/Refine", { **options }.compact)
        end

        # Queries the status of an asynchronous responsive-ad recommendation job
        # (GetResponsiveAdRecommendationJob).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields vary by implementation; typically includes a job identifier.
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object describing the job status and any completed results.
        def responsive_ad_recommendation_job(**options)
          post("/ResponsiveAdRecommendationJob/Query", { **options }.compact)
        end

        # Generates recommended responsive-search-ad assets from one or more landing-page
        # URLs (CreateResponsiveSearchAdRecommendation).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields: +FinalUrls+ (required, array of URLs), +Prompt+ (optional),
        # +TextTone+ (optional AdRecommendationTextTone).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +responsive_search_ad+.
        def create_responsive_search_ad_recommendation(**options)
          post("/ResponsiveSearchAdRecommendation/Create", { **options }.compact)
        end

        # Refines a previously generated responsive-search-ad recommendation
        # (RefineResponsiveSearchAdRecommendation).
        #
        # Accepts any keyword arguments and passes them through as the request body.
        # Key fields: +ResponsiveSearchAd+ (reserved, ResponsiveSearchAd object),
        # +TextRefineOperations+ (reserved, array of AdRecommendationTextRefineOperation).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +text_refine_results+.
        def refine_responsive_search_ad_recommendation(**options)
          post("/ResponsiveSearchAdRecommendation/Refine", { **options }.compact)
        end
      end
    end
  end
end
