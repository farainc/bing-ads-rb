# frozen_string_literal: true

module BingAds
  # Per-service namespaces exposed on the client, e.g.
  #   client.campaign_management.campaigns.list
  #   client.customer_management.users.me
  #   client.reporting.reports.submit(...)
  #   client.bulk.files.download_by_account_ids(...)
  module Services
    class Base
      # Defines a memoized resource accessor, e.g.
      #   resource :campaigns, "CampaignManagement::Campaigns"
      def self.resource(name, klass_name)
        define_method(name) do
          @mutex.synchronize do
            @resources[name] ||= Resources.const_get(klass_name).new(@client)
          end
        end
      end

      def initialize(client)
        @client = client
        @resources = {}
        @mutex = Mutex.new
      end
    end

    class CampaignManagement < Base
      resource :campaigns, "CampaignManagement::Campaigns"
      resource :campaign_conversion_goals, "CampaignManagement::CampaignConversionGoals"
      resource :negative_sites, "CampaignManagement::NegativeSites"
      resource :ad_groups, "CampaignManagement::AdGroups"
      resource :ads, "CampaignManagement::Ads"
      resource :keywords, "CampaignManagement::Keywords"
      resource :ad_extensions, "CampaignManagement::AdExtensions"
      resource :budgets, "CampaignManagement::Budgets"
      resource :bid_strategies, "CampaignManagement::BidStrategies"
      resource :audiences, "CampaignManagement::Audiences"
      resource :audience_groups, "CampaignManagement::AudienceGroups"
      resource :campaign_criterions, "CampaignManagement::CampaignCriterions"
      resource :ad_group_criterions, "CampaignManagement::AdGroupCriterions"
      resource :negative_keywords, "CampaignManagement::NegativeKeywords"
      resource :shared_entities, "CampaignManagement::SharedEntities"
      resource :labels, "CampaignManagement::Labels"
      resource :experiments, "CampaignManagement::Experiments"
      resource :import_jobs, "CampaignManagement::ImportJobs"
      resource :uet_tags, "CampaignManagement::UetTags"
      resource :conversion_goals, "CampaignManagement::ConversionGoals"
      resource :conversion_value_rules, "CampaignManagement::ConversionValueRules"
      resource :media, "CampaignManagement::Media"
      resource :videos, "CampaignManagement::Videos"
      resource :html5s, "CampaignManagement::HTML5s"
      resource :asset_groups, "CampaignManagement::AssetGroups"
      resource :brand_kits, "CampaignManagement::BrandKits"
      resource :seasonality_adjustments, "CampaignManagement::SeasonalityAdjustments"
      resource :data_exclusions, "CampaignManagement::DataExclusions"
      resource :offline_conversions, "CampaignManagement::OfflineConversions"
      resource :new_customer_acquisition_goals, "CampaignManagement::NewCustomerAcquisitionGoals"
      resource :linked_in_segments, "CampaignManagement::LinkedInSegments"
      resource :recommendations, "CampaignManagement::Recommendations"
      resource :editorial, "CampaignManagement::Editorial"
      resource :utilities, "CampaignManagement::Utilities"
    end

    class CustomerManagement < Base
      resource :users, "CustomerManagement::Users"
      resource :accounts, "CustomerManagement::Accounts"
      resource :customers, "CustomerManagement::Customers"
      resource :client_links, "CustomerManagement::ClientLinks"
      resource :user_invitations, "CustomerManagement::UserInvitations"
      resource :notifications, "CustomerManagement::Notifications"
    end

    class CustomerBilling < Base
      resource :billing_documents, "CustomerBilling::BillingDocuments"
      resource :insertion_orders, "CustomerBilling::InsertionOrders"
      resource :billing_groups, "CustomerBilling::BillingGroups"
      resource :coupons, "CustomerBilling::Coupons"
    end

    class AdInsight < Base
      resource :keyword_ideas, "AdInsight::KeywordIdeas"
      resource :keyword_estimates, "AdInsight::KeywordEstimates"
      resource :bid_landscapes, "AdInsight::BidLandscapes"
      resource :opportunities, "AdInsight::Opportunities"
      resource :historical, "AdInsight::Historical"
      resource :recommendations, "AdInsight::Recommendations"
      resource :insights, "AdInsight::Insights"
    end

    class Reporting < Base
      resource :reports, "Reporting::Reports"
    end

    class Bulk < Base
      resource :files, "Bulk::Files"
    end
  end
end
