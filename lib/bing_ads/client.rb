# frozen_string_literal: true

module BingAds
  class Client
    attr_reader :developer_token, :oauth, :customer_id, :account_id,
                :env, :connection

    # Remaining options are forwarded to Connection.new (logger:,
    # max_retries:, open_timeout:, read_timeout:, sleeper:); pass
    # connection: to inject a prebuilt connection instead.
    def initialize(developer_token:, oauth:, customer_id: nil, account_id: nil, env: :production, **options)
      @developer_token = developer_token
      @oauth = oauth
      @customer_id = customer_id
      @account_id  = account_id
      @env = env
      @services = {}
      @connection = options.delete(:connection) || Connection.new(**options)
      @mutex = Mutex.new
    end

    def campaign_management
      service(:campaign_management) { Services::CampaignManagement.new(self) }
    end

    def customer_management
      service(:customer_management) { Services::CustomerManagement.new(self) }
    end

    def customer_billing
      service(:customer_billing) { Services::CustomerBilling.new(self) }
    end

    def ad_insight
      service(:ad_insight) { Services::AdInsight.new(self) }
    end

    def reporting
      service(:reporting) { Services::Reporting.new(self) }
    end

    def bulk
      service(:bulk) { Services::Bulk.new(self) }
    end

    # Releases the calling thread's pooled keep-alive connections.
    # Optional — sockets are reclaimed at process exit anyway — but
    # useful for long-lived processes done talking to the API.
    def shutdown
      connection.shutdown
    end

    def execute(service:, method:, path:, body: nil, customer_id: nil, account_id: nil)
      url = Environment.base_url(env, service) + path
      cid = customer_id || self.customer_id
      aid = account_id || self.account_id
      refreshed = false
      begin
        connection.request(method, url,
                           headers: auth_headers(customer_id: cid, account_id: aid),
                           body: body)
      rescue HTTPError => e
        raise if refreshed || !token_expired_error?(e)

        oauth.refresh!
        refreshed = true
        retry
      end
    end

    private

    def service(name)
      @mutex.synchronize do
        @services[name] ||= yield
      end
    end

    # All four headers go to every service, matching the official
    # Python SDK. Customer Management/Billing REST docs list only
    # Authorization + DeveloperToken, but the id headers are ignored
    # there (ids travel in the request body for those services).
    def auth_headers(customer_id:, account_id:)
      {
        "Authorization" => "Bearer #{oauth.access_token!}",
        "DeveloperToken" => developer_token
      }.tap do |headers|
        headers["IdentityProvider"] = oauth.identity_provider if oauth.identity_provider
        headers["CustomerId"] = customer_id.to_s if customer_id
        headers["CustomerAccountId"] = account_id.to_s if account_id
      end
    end

    # 401 responses and operation error code 109 both signal an
    # expired access token.
    def token_expired_error?(error)
      return true if error.is_a?(AuthenticationError)

      error.errors.any? { |e| e.is_a?(::Hash) && e["Code"] == 109 }
    end
  end
end
