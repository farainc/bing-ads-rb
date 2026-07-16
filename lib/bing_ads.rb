# frozen_string_literal: true

require_relative "bing_ads/version"
require_relative "bing_ads/utils"
require_relative "bing_ads/errors"
require_relative "bing_ads/environment"
require_relative "bing_ads/object"
require_relative "bing_ads/zip"
require_relative "bing_ads/polling"
require_relative "bing_ads/report_file"
require_relative "bing_ads/oauth/tokens"
require_relative "bing_ads/oauth/authorization"
require_relative "bing_ads/oauth/web_auth_code_grant"
require_relative "bing_ads/oauth/desktop_mobile_auth_code_grant"
require_relative "bing_ads/oauth/google_web_auth_code_grant"
require_relative "bing_ads/oauth/google_desktop_mobile_auth_code_grant"
require_relative "bing_ads/connection"
require_relative "bing_ads/services"
require_relative "bing_ads/client"
require_relative "bing_ads/resources/base"
require_relative "bing_ads/resources/result_file"
require_relative "bing_ads/resources/campaign_management/campaigns"
require_relative "bing_ads/resources/campaign_management/campaign_conversion_goals"
require_relative "bing_ads/resources/campaign_management/negative_sites"
require_relative "bing_ads/resources/campaign_management/ad_groups"
require_relative "bing_ads/resources/campaign_management/ads"
require_relative "bing_ads/resources/campaign_management/keywords"
require_relative "bing_ads/resources/campaign_management/ad_extensions"
require_relative "bing_ads/resources/campaign_management/budgets"
require_relative "bing_ads/resources/campaign_management/bid_strategies"
require_relative "bing_ads/resources/campaign_management/audiences"
require_relative "bing_ads/resources/campaign_management/audience_groups"
require_relative "bing_ads/resources/campaign_management/campaign_criterions"
require_relative "bing_ads/resources/campaign_management/ad_group_criterions"
require_relative "bing_ads/resources/campaign_management/negative_keywords"
require_relative "bing_ads/resources/campaign_management/shared_entities"
require_relative "bing_ads/resources/campaign_management/labels"
require_relative "bing_ads/resources/campaign_management/experiments"
require_relative "bing_ads/resources/campaign_management/import_jobs"
require_relative "bing_ads/resources/campaign_management/uet_tags"
require_relative "bing_ads/resources/campaign_management/conversion_goals"
require_relative "bing_ads/resources/campaign_management/conversion_value_rules"
require_relative "bing_ads/resources/campaign_management/media"
require_relative "bing_ads/resources/campaign_management/videos"
require_relative "bing_ads/resources/campaign_management/html5s"
require_relative "bing_ads/resources/campaign_management/asset_groups"
require_relative "bing_ads/resources/campaign_management/brand_kits"
require_relative "bing_ads/resources/campaign_management/seasonality_adjustments"
require_relative "bing_ads/resources/campaign_management/data_exclusions"
require_relative "bing_ads/resources/campaign_management/offline_conversions"
require_relative "bing_ads/resources/campaign_management/new_customer_acquisition_goals"
require_relative "bing_ads/resources/campaign_management/linked_in_segments"
require_relative "bing_ads/resources/campaign_management/recommendations"
require_relative "bing_ads/resources/campaign_management/editorial"
require_relative "bing_ads/resources/campaign_management/utilities"
require_relative "bing_ads/resources/customer_management/users"
require_relative "bing_ads/resources/customer_management/accounts"
require_relative "bing_ads/resources/customer_management/customers"
require_relative "bing_ads/resources/customer_management/client_links"
require_relative "bing_ads/resources/customer_management/user_invitations"
require_relative "bing_ads/resources/customer_management/notifications"
require_relative "bing_ads/resources/customer_billing/billing_documents"
require_relative "bing_ads/resources/customer_billing/insertion_orders"
require_relative "bing_ads/resources/customer_billing/billing_groups"
require_relative "bing_ads/resources/customer_billing/coupons"
require_relative "bing_ads/resources/ad_insight/keyword_ideas"
require_relative "bing_ads/resources/ad_insight/keyword_estimates"
require_relative "bing_ads/resources/ad_insight/bid_landscapes"
require_relative "bing_ads/resources/ad_insight/opportunities"
require_relative "bing_ads/resources/ad_insight/historical"
require_relative "bing_ads/resources/ad_insight/recommendations"
require_relative "bing_ads/resources/ad_insight/insights"
require_relative "bing_ads/resources/reporting/operation"
require_relative "bing_ads/resources/reporting/reports"
require_relative "bing_ads/resources/bulk/operation"
require_relative "bing_ads/resources/bulk/files"

module BingAds
  # Body keys whose PascalCase form is not a simple capitalize.
  # String keys always pass through verbatim, so this map is a
  # convenience, not the only escape hatch.
  DEFAULT_ACRONYMS = { "utc" => "UTC", "html5" => "HTML5", "html5s" => "HTML5s" }.freeze

  @acronyms = DEFAULT_ACRONYMS

  class << self
    # The active snake_case-segment => PascalCase-segment map (frozen).
    attr_reader :acronyms

    # Registers extra acronym mappings for key camelization, e.g.
    #   BingAds.register_acronyms("sku" => "SKU")
    # makes :sku_ids camelize to "SKUIds". Copy-on-write: readers
    # always see a frozen snapshot, so registration (typically at
    # boot) is safe against concurrent requests.
    def register_acronyms(mapping)
      @acronyms = @acronyms.merge(mapping.transform_keys { |k| k.to_s.downcase }).freeze
    end
  end
end
