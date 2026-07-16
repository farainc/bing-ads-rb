# frozen_string_literal: true

module BingAds
  module Resources
    module AdInsight
      # Historical keyword performance and search count operations
      # (GetHistoricalKeywordPerformance, GetHistoricalSearchCount).
      class Historical < Base
        service :ad_insight

        # Returns historical performance data for keywords (GetHistoricalKeywordPerformance).
        #
        # +keywords+:: List of keywords to get historical performance data for.
        # +language+:: Language of the keywords.
        # +match_types+:: List of match types to include in the results.
        # +time_interval+:: Optional. Time interval over which to aggregate the data, e.g.
        #                   <tt>"LastMonth"</tt> or <tt>"LastYear"</tt>. Default is LastDay.
        # +target_ad_position+:: Optional. Target ad position for the historical data, e.g.
        #                        <tt>"MainLine1"</tt>. Default is All.
        # +publisher_countries+:: Optional. List of publisher country codes to scope the data.
        #                         If null, includes all publisher countries.
        # +devices+:: Optional. List of devices to include in the results.
        #             Default is Computers.
        #
        # Returns an object with +keyword_historical_performances+.
        def keyword_performance(keywords:, language:, match_types:, time_interval: nil,
                                target_ad_position: nil, publisher_countries: nil,
                                devices: nil, **options)
          post("/HistoricalKeywordPerformance/Query",
               { keywords: keywords, time_interval: time_interval,
                 target_ad_position: target_ad_position, match_types: match_types,
                 language: language, publisher_countries: publisher_countries,
                 devices: devices, **options }.compact)
        end

        # Returns historical search count data for keywords (GetHistoricalSearchCount).
        #
        # +keywords+:: List of keywords to get historical search count data for.
        # +language+:: Language of the keywords.
        # +start_date+:: Start of the date range for the historical data.
        # +end_date+:: End of the date range for the historical data.
        # +time_period_rollup+:: Time granularity for aggregating search counts, e.g.
        #                        <tt>"Monthly"</tt>.
        # +publisher_countries+:: Optional. List of publisher country codes to scope the data.
        #                         If null, default is all publisher countries.
        # +devices+:: Optional. List of devices to include in the results.
        #             Default is Computers.
        # +options+:: Optional. Any additional request fields not listed above,
        #             forwarded to the API verbatim.
        #
        # Returns an object with +keyword_search_counts+.
        def search_count(keywords:, language:, start_date:, end_date:, time_period_rollup:,
                         publisher_countries: nil, devices: nil, **options)
          post("/HistoricalSearchCount/Query",
               { keywords: keywords, language: language, publisher_countries: publisher_countries,
                 start_date: start_date, end_date: end_date,
                 time_period_rollup: time_period_rollup, devices: devices, **options }.compact)
        end
      end
    end
  end
end
