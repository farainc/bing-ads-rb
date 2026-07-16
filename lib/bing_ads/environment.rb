# frozen_string_literal: true

module BingAds
  module Environment
    PRODUCTION = {
      campaign_management: "https://campaign.api.bingads.microsoft.com/CampaignManagement/v13",
      customer_management: "https://clientcenter.api.bingads.microsoft.com/CustomerManagement/v13",
      customer_billing: "https://clientcenter.api.bingads.microsoft.com/CustomerBilling/v13",
      ad_insight: "https://adinsight.api.bingads.microsoft.com/AdInsight/v13",
      reporting: "https://reporting.api.bingads.microsoft.com/Reporting/v13",
      bulk: "https://bulk.api.bingads.microsoft.com/Bulk/v13"
    }.freeze

    SANDBOX = {
      campaign_management: "https://campaign.api.sandbox.bingads.microsoft.com/CampaignManagement/v13",
      customer_management: "https://clientcenter.api.sandbox.bingads.microsoft.com/CustomerManagement/v13",
      customer_billing: "https://clientcenter.api.sandbox.bingads.microsoft.com/CustomerBilling/v13",
      ad_insight: "https://adinsight.api.sandbox.bingads.microsoft.com/AdInsight/v13",
      reporting: "https://reporting.api.sandbox.bingads.microsoft.com/Reporting/v13",
      bulk: "https://bulk.api.sandbox.bingads.microsoft.com/Bulk/v13"
    }.freeze

    def self.base_url(environment, service)
      urls = case environment
             when :production then PRODUCTION
             when :sandbox then SANDBOX
             else raise ArgumentError, "unknown environment: #{environment.inspect}"
             end
      urls.fetch(service) { raise ArgumentError, "unknown service: #{service.inspect}" }
    end
  end
end
