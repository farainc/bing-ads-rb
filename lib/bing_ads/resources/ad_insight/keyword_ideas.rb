# frozen_string_literal: true

module BingAds
  module Resources
    module AdInsight
      # Keyword idea and suggestion operations (GetKeywordIdeas, GetKeywordIdeaCategories,
      # GetKeywordCategories, GetKeywordDemographics, GetKeywordLocations,
      # SuggestKeywordsForUrl, SuggestKeywordsFromExistingKeywords).
      class KeywordIdeas < Base
        service :ad_insight

        # Returns a list of keyword ideas (GetKeywordIdeas).
        #
        # +expand_ideas+:: Whether to return expanded ideas related to the search
        #                  parameters.
        # +idea_attributes+:: List of keyword idea attributes to include in the
        #                     response.
        # +search_parameters+:: List of search parameters that filter the keyword
        #                       ideas returned.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_ideas+.
        def ideas(expand_ideas:, idea_attributes:, search_parameters:, **options)
          post("/KeywordIdeas/Query",
               { expand_ideas: expand_ideas, idea_attributes: idea_attributes,
                 search_parameters: search_parameters, **options }.compact)
        end

        # Returns a list of keyword idea categories (GetKeywordIdeaCategories).
        #
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +category_ids+.
        def idea_categories(**options)
          post("/KeywordIdeaCategories/Query", { **options }.compact)
        end

        # Returns a list of keyword categories (GetKeywordCategories).
        #
        # +keywords+:: List of keywords to categorize.
        # +language+:: Language of the keywords.
        # +publisher_country+:: Country code of the publisher.
        # +max_categories+:: Maximum number of categories to return per keyword.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_categories+.
        def categories(keywords:, language:, publisher_country:, max_categories:, **options)
          post("/KeywordCategories/Query",
               { keywords: keywords, language: language, publisher_country: publisher_country,
                 max_categories: max_categories, **options }.compact)
        end

        # Returns keyword demographic data (GetKeywordDemographics).
        #
        # +keywords+:: List of keywords to get demographics for.
        # +language+:: Language of the keywords.
        # +publisher_country+:: Country code of the publisher.
        # +device+:: List of devices to get demographic data for.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_demographic_result+.
        def demographics(keywords:, language:, publisher_country:, device:, **options)
          post("/KeywordDemographics/Query",
               { keywords: keywords, language: language, publisher_country: publisher_country,
                 device: device, **options }.compact)
        end

        # Returns keyword location data (GetKeywordLocations).
        #
        # +keywords+:: List of keywords to get location data for.
        # +language+:: Language of the keywords.
        # +publisher_country+:: Country code of the publisher.
        # +device+:: List of devices to get location data for.
        # +level+:: Geographical level of the location data.
        # +parent_country+:: Parent country for the location results.
        # +max_locations+:: Maximum number of locations to return per keyword.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_location_result+.
        def locations(keywords:, language:, publisher_country:, device:,
                      level:, parent_country:, max_locations:, **options)
          post("/KeywordLocations/Query",
               { keywords: keywords, language: language, publisher_country: publisher_country,
                 device: device, level: level, parent_country: parent_country,
                 max_locations: max_locations, **options }.compact)
        end

        # Returns keyword suggestions for a URL (SuggestKeywordsForUrl).
        #
        # +url+:: URL from which to extract keyword suggestions.
        # +language+:: Optional. Language of the returned keyword suggestions.
        #              Defaults to English if not specified.
        # +max_keywords+:: Optional. Maximum number of keywords to return.
        #                  Defaults to 10 if not specified.
        # +min_confidence_score+:: Optional. Minimum confidence score (0.0–1.0) for returned
        #                          suggestions. If null, not used as a filter.
        # +exclude_brand+:: Optional. Whether to exclude brand keywords from the results.
        #                   Defaults to false if not specified.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keywords+.
        def suggest_for_url(url:, language: nil, max_keywords: nil, min_confidence_score: nil,
                            exclude_brand: nil, **options)
          post("/KeywordSuggestions/QueryByUrl",
               { url: url, language: language, max_keywords: max_keywords,
                 min_confidence_score: min_confidence_score, exclude_brand: exclude_brand, **options }.compact)
        end

        # Returns keyword suggestions based on existing keywords (SuggestKeywordsFromExistingKeywords).
        #
        # +keywords+:: List of seed keywords to base suggestions on.
        # +language+:: Optional. Language of the returned keyword suggestions.
        #              Defaults to English if not specified.
        # +publisher_countries+:: Optional. List of publisher countries to scope the suggestions.
        #                         Defaults to all publisher countries if not specified.
        # +max_suggestions_per_keyword+:: Optional. Maximum number of suggestions per seed keyword.
        #                                 Defaults to 50 if not specified.
        # +suggestion_type+:: Optional. Type of keyword suggestions to return.
        #                     Note: no longer supported as of January 2026.
        # +remove_duplicates+:: Optional. Whether to remove duplicate keywords from the results.
        #                       Defaults to false if not specified.
        # +exclude_brand+:: Optional. Whether to exclude brand keywords from the results.
        #                   Defaults to false if not specified.
        # +ad_group_id+:: Optional. Ad group identifier to scope the suggestions.
        #                 Note: not yet supported.
        # +campaign_id+:: Optional. Campaign identifier to scope the suggestions.
        #                 Note: not yet supported.
        #
        # Returns an object with +keywords+.
        def suggest_from_existing(keywords:, language: nil, publisher_countries: nil,
                                  max_suggestions_per_keyword: nil, suggestion_type: nil,
                                  remove_duplicates: nil, exclude_brand: nil,
                                  ad_group_id: nil, campaign_id: nil, **options)
          post("/KeywordSuggestions/QueryByKeywords",
               { keywords: keywords, language: language, publisher_countries: publisher_countries,
                 max_suggestions_per_keyword: max_suggestions_per_keyword,
                 suggestion_type: suggestion_type, remove_duplicates: remove_duplicates,
                 exclude_brand: exclude_brand, ad_group_id: ad_group_id,
                 campaign_id: campaign_id, **options }.compact)
        end
      end
    end
  end
end
