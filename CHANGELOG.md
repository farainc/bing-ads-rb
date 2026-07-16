# Changelog

## [Unreleased]

## [0.1.0] - 2026-07-16

Initial release: Microsoft Advertising (Bing Ads) v13 REST API client.

- OAuth authorization-code grants (web + desktop/mobile with PKCE, Google
  identity variants) with automatic access-token refresh and an
  `on_tokens_refreshed` persistence callback
- `BingAds::Client` with per-service headers, sandbox/production
  environments, retries with exponential backoff and `Retry-After` support
- Campaign Management: 160+ REST operations across 29 resources
- Customer Management, Customer Billing, and Ad Insight resources
- Reporting: submit/poll operations plus a managed
  submit → poll → download → unzip workflow
- Bulk: download/upload operations plus managed workflows with automatic
  CSV zipping and multipart upload
- Response objects with snake_case readers; request bodies accept
  snake_case symbol keys (camelized automatically)
