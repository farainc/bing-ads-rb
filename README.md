# BingAds

> **Unofficial** Ruby client for Microsoft Advertising — not affiliated with or endorsed by Microsoft.

Ruby client for the [Microsoft Advertising (Bing Ads) v13 REST API](https://learn.microsoft.com/en-us/advertising/guides/).
Covers the same surface as the official [BingAds-Python-SDK](https://github.com/BingAds/BingAds-Python-SDK) —
all six services plus OAuth token management and the managed async
Reporting/Bulk workflows — but speaks the JSON REST endpoints instead of SOAP.

- **Campaign Management** — 160+ operations: campaigns, ad groups, ads, keywords,
  ad extensions, budgets, bid strategies, audiences, criterions, labels,
  conversion goals, UET tags, experiments, import jobs, asset groups, and more
- **Customer Management** — users, accounts, customers, client links, invitations
- **Customer Billing** — billing documents, insertion orders, billing groups, coupons
- **Ad Insight** — keyword ideas, traffic estimates, bid landscapes, opportunities
- **Reporting** — submit → poll → download → unzip, in one call
- **Bulk** — managed download and upload (CSV auto-zipped, multipart upload)

## Installation

```ruby
gem "bing_ads"
```

## Authentication

Microsoft identity platform OAuth with automatic access-token refresh.

```ruby
# Server-side web app (confidential client)
oauth = BingAds::OAuth::WebAuthCodeGrant.new(
  client_id: ENV["BING_ADS_CLIENT_ID"],
  client_secret: ENV["BING_ADS_CLIENT_SECRET"],
  redirect_uri: "https://app.example.com/callback"
)

# 1. Send the user to consent:
oauth.authorization_url(state: csrf_token)

# 2. Exchange the code from the redirect:
oauth.fetch_tokens(code: params[:code])   # or fetch_tokens_from_response_uri(request.url)

# 3. Persist the refresh token; restore sessions later with:
oauth.refresh!(refresh_token: saved_refresh_token)

# Fired on every token acquisition/refresh — persist the newest refresh token:
oauth.on_tokens_refreshed { |tokens| store.save(tokens.refresh_token) }
```

Native/desktop apps use `BingAds::OAuth::DesktopMobileAuthCodeGrant.new(client_id: "...")`
(nativeclient redirect URI, PKCE S256, no client secret). Google identity is
supported via `GoogleWebAuthCodeGrant` / `GoogleDesktopMobileAuthCodeGrant`.

## Client

```ruby
client = BingAds::Client.new(
  developer_token: ENV["BING_ADS_DEVELOPER_TOKEN"],
  oauth: oauth,
  customer_id: 123456,     # manager account
  account_id: 654321,      # ad account (overridable per call)
  env: :production         # or :sandbox
)
```

Expired access tokens refresh automatically (proactively and on 401/error 109);
transient failures (429, 5xx, network errors) retry with exponential backoff
honoring `Retry-After`.

## Campaign Management

```ruby
result = client.campaign_management.campaigns.create(campaigns: [{
  name: "Summer Sale",
  campaign_type: "Search",
  daily_budget: 50.0,
  budget_type: "DailyBudgetStandard",
  time_zone: "PacificTimeUSCanada",
  bidding_scheme: { type: "ManualCpcBiddingScheme" }
}])
result.campaign_ids     #=> ["98765432101"]
result.partial_errors   #=> [nil]  (per-item errors; nil = success)

campaigns = client.campaign_management.campaigns.list(campaign_type: "Search")
campaigns.campaigns.each { |c| puts "#{c.id} #{c.name}" }

cm = client.campaign_management

# Build out the campaign: ad group → responsive search ad → keywords
ad_groups = cm.ad_groups.create(
  campaign_id: 98765432101,
  ad_groups: [{ name: "Shoes", cpc_bid: { amount: 1.2 }, start_date: nil }]
)
ad_group_id = ad_groups.ad_group_ids.first

cm.ads.create(ad_group_id: ad_group_id, ads: [{
  type: "ResponsiveSearchAd",
  headlines: [{ text: "Run Faster" }, { text: "Shoes On Sale" }, { text: "Free Shipping" }],
  descriptions: [{ text: "Top brands up to 50% off." }, { text: "Order today." }],
  final_urls: ["https://example.com/shoes"]
}])

cm.keywords.create(ad_group_id: ad_group_id, keywords: [
  { text: "running shoes", match_type: "Exact", bid: { amount: 1.5 } },
  { text: "trail shoes",   match_type: "Phrase" }
])

# Negative keywords, budgets, labels, audiences, ... follow the same shape:
cm.negative_keywords.add_to_entities(entity_negative_keywords: [{
  entity_id: 98765432101, entity_type: "Campaign",
  negative_keywords: [{ text: "free", match_type: "Exact" }]
}])

cm.campaigns.update(campaigns: [{ id: 98765432101, status: "Paused" }])
cm.campaigns.delete(campaign_ids: [98765432101])

# Work across accounts by overriding account_id per call:
cm.campaigns.list(account_id: 111222333)
```

Symbol keys camelize automatically (`daily_budget` → `DailyBudget`,
`type:` → `Type`); String keys pass through verbatim (useful for exact
keys like `"HTML5s"` or `ForwardCompatibilityMap`'s lowercase `key`/`value`).
Responses support snake_case readers plus raw access:

```ruby
campaign = client.campaign_management.campaigns.list.campaigns.first
campaign.bidding_scheme.type   #=> "ManualCpcBiddingScheme"
campaign["DailyBudget"]        #=> 50.0
campaign.to_h                  #=> raw response hash
```

Camelization handles acronym segments through a registry
(`utc`/`html5` ship built in — `:last_sync_time_in_utc` →
`"LastSyncTimeInUTC"`). If an API field uses a casing that plain
capitalization can't produce, register it once at boot:

```ruby
BingAds.register_acronyms("sku" => "SKU", "roas" => "ROAS")

BingAds::Utils.camelize(:sku_ids)      #=> "SKUIds"
BingAds::Utils.camelize(:target_roas)  #=> "TargetROAS"

# One-off alternative without touching the registry — String keys are
# sent verbatim:
client.campaign_management.campaigns.list("ReturnAdditionalFields" => "TargetROAS")
```

Flags enums (`campaign_type`, `conversion_goal_types`, `return_additional_fields`, …)
accept an Array or a comma/space-separated String and are normalized to the
comma-joined form the REST API requires — space-joined strings alone fail the
whole request with `100 NullRequest`.

## Customer Management

```ruby
me = client.customer_management.users.me
me.user.user_name              #=> current authenticated user

accounts = client.customer_management.accounts.search(
  predicates: [{ field: "UserId", operator: "Equals", value: me.user.id }],
  page_info: { index: 0, size: 100 }
)
accounts.accounts.each { |a| puts "#{a.id} #{a.name} (#{a.number})" }

client.customer_management.accounts.find(account_id: 654321)
client.customer_management.customers.info
client.customer_management.customers.linked_accounts_and_customers_info(customer_id: 123456)
```

## Ad Insight

```ruby
adi = client.ad_insight

ideas = adi.keyword_ideas.ideas(
  expand_ideas: true,
  idea_attributes: %w[Keyword MonthlySearchCounts SuggestedBid Competition],
  search_parameters: [
    { type: "QuerySearchParameter", queries: ["running shoes"] },
    { type: "LanguageSearchParameter", languages: [{ language: "English" }] },
    { type: "LocationSearchParameter", locations: [{ location_id: 190 }] }
  ]
)
ideas.keyword_ideas.each { |i| puts "#{i.keyword} #{i.suggested_bid}" }

adi.keyword_estimates.traffic(keywords: [{ keyword: { text: "shoes", match_type: "Exact" } }])
adi.bid_landscapes.list_by_keyword_ids(keyword_ids: [555])
adi.opportunities.budgets(campaign_id: 98765432101)
```

## Customer Billing

```ruby
client.customer_billing.billing_documents.info(
  accounts: [{ account_id: 654321 }],
  start_date: { year: 2026, month: 1, day: 1 },
  end_date: { year: 2026, month: 6, day: 30 }
)
client.customer_billing.billing_documents.monthly_spend(account_id: 654321, month_year: "2026-06")
client.customer_billing.insertion_orders.search(
  predicates: [{ field: "AccountId", operator: "Equals", value: "654321" }]
)
```

## Reporting

```ruby
path = client.reporting.reports.download(
  {
    type: "CampaignPerformanceReportRequest",
    format: "Csv",
    aggregation: "Daily",
    columns: %w[TimePeriod CampaignName Impressions Clicks Spend],
    scope: { account_ids: [654321] },
    time: { predefined_time: "LastMonth" }
  },
  path: "./reports/campaigns_last_month.csv"
)
# Submit → poll (1s × 5, then every 5s) → download → unzip to exactly
# the given path. nil when the report has no data.

BingAds::ReportFile.each_row(path) { |row| puts "#{row["TimePeriod"]}: #{row["Clicks"]}" }
```

Or track manually — submit now, download later:

```ruby
operation = client.reporting.reports.submit(report_request)
operation.request_id                 # persist it; valid for ~1 day
tracking = operation.track(timeout: 1800)
tracking.status                     #=> "Success"
operation.download_result_file(path: "./reports/june.csv", overwrite: true)
```

## Bulk

```ruby
# Download all campaign data as a bulk CSV (one call: submit → poll → fetch → unzip)
path = client.bulk.files.download(
  entities: %w[Campaigns AdGroups Keywords],
  path: "./bulk/full_sync.csv"
)

# Incremental sync since the last download:
client.bulk.files.download(
  entities: %w[Keywords],
  last_sync_time_in_utc: "2026-07-01T00:00:00Z",
  path: "./bulk/keywords_delta.csv"
)

# Upload a bulk CSV (auto-zipped with a UTF-8 BOM) and fetch the result file
result = client.bulk.files.upload(file: "./changes.csv", result_path: "./bulk/upload_result.csv")

# Or drive the workflow yourself:
operation = client.bulk.files.submit_download(entities: %w[Campaigns])
operation.status.percent_complete    # raw GetBulkDownloadStatus call
operation.track                      # poll until Completed / raise on failure
operation.download_result_file(path: "./bulk/full_sync.csv")
```

Failed operations raise `BingAds::OperationFailedError` with `status`/`errors`.

## Errors

`BingAds::Error` → `OAuthError`, `NetworkError`,
`OperationFailedError`, and `HTTPError` subclasses (`AuthenticationError`,
`ForbiddenError`, `NotFoundError`, `ValidationError`, `RateLimitError`,
`ServerError`) carrying `status`, `code`, `errors`, `tracking_id`.

```ruby
begin
  result = client.campaign_management.campaigns.create(campaigns: campaigns)

  # Batch operations return per-item PartialErrors instead of raising:
  result.partial_errors.each_with_index do |error, index|
    next if error.nil?

    warn "campaign ##{index} rejected: #{error["ErrorCode"]} #{error["Message"]}"
  end
rescue BingAds::ValidationError => e
  warn "bad request #{e.code}: #{e.message} (TrackingId: #{e.tracking_id})"
rescue BingAds::OAuthError => e
  redirect_to_consent if e.code == "invalid_grant" # refresh token revoked/expired
rescue BingAds::Error => e
  raise unless e.retryable?

  retry_later
end
```

Transient failures (429/5xx/network) are already retried with exponential
backoff before an error ever reaches you.

## Python SDK mapping

| Python SDK                                       | This gem                                                   |
| ------------------------------------------------ | ---------------------------------------------------------- |
| `OAuthWebAuthCodeGrant`                          | `BingAds::OAuth::WebAuthCodeGrant`                         |
| `OAuthDesktopMobileAuthCodeGrant`                | `BingAds::OAuth::DesktopMobileAuthCodeGrant`               |
| `token_refreshed_callback`                       | `oauth.on_tokens_refreshed { ... }`                        |
| `AuthorizationData`                              | `BingAds::Client.new(...)` kwargs                          |
| `ServiceClient("CampaignManagementService")`     | `client.campaign_management.campaigns` / `.keywords` / ... |
| `ServiceClient("CustomerManagementService")`     | `client.customer_management.users` / `.accounts` / ...     |
| `ReportingServiceManager.download_file`          | `client.reporting.reports.download`                        |
| `BulkServiceManager.download_file / upload_file` | `client.bulk.files.download` / `.upload`                   |
| `ReportFileReader`                               | `BingAds::ReportFile.each_row`                             |

Not ported: the strongly-typed Bulk entity classes (`BulkCampaign` etc.) —
bulk files are read/written as CSV rows in this version — and the deprecated
implicit OAuth grant.

## Development

After checking out the repo, run `bundle install`. Then:

```bash
bundle exec rake test
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/farainc/bing-ads-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
