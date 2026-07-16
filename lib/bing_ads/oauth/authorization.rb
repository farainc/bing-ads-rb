# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module BingAds
  module OAuth
    # Base authorization-code grant. Subclasses override the private
    # endpoint/scope/extra-param hooks.
    class Authorization
      AUTHORIZE_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
      TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
      SCOPE = "openid profile https://ads.microsoft.com/msads.manage offline_access"

      attr_reader :client_id, :redirect_uri, :env
      attr_accessor :tokens

      def initialize(client_id:, redirect_uri:, env: :production)
        @client_id = client_id
        @redirect_uri = redirect_uri
        @env = env
        @tokens = nil
        @on_tokens_refreshed = nil
        @mutex = Mutex.new
      end

      def on_tokens_refreshed(&block)
        @on_tokens_refreshed = block
      end

      def authorization_url(state: nil, **extra)
        params = {
          "client_id" => client_id,
          "response_type" => "code",
          "redirect_uri" => redirect_uri,
          "scope" => scope
        }
        params["state"] = state if state
        params.merge!(authorization_extra_params)
        extra.each { |k, v| params[k.to_s] = v }
        "#{authorize_url}?#{URI.encode_www_form(params)}"
      end

      def fetch_tokens(code:)
        request_tokens(
          "grant_type" => "authorization_code",
          "code" => code,
          "redirect_uri" => redirect_uri
        )
      end

      def fetch_tokens_from_response_uri(response_uri)
        query = URI(response_uri).query
        raise OAuthError, "response URI has no query string" unless query

        params = URI.decode_www_form(query).to_h
        if params["error"]
          raise OAuthError.new(params["error_description"] || params["error"],
                               code: params["error"], description: params["error_description"])
        end

        code = params["code"]
        raise OAuthError, "response URI has no code parameter" unless code

        fetch_tokens(code: code)
      end

      def refresh!(refresh_token: nil)
        @mutex.synchronize { refresh(refresh_token: refresh_token) }
      end

      # Returns a currently-valid access token, refreshing first if the
      # cached one is expired (or about to expire). Concurrent callers
      # coordinate through the mutex, so an expired token is refreshed
      # exactly once — important because Microsoft rotates refresh
      # tokens and a racing second refresh could invalidate the first.
      def access_token!
        raise OAuthError, "not authorized: call fetch_tokens or refresh!(refresh_token:) first" unless tokens

        @mutex.synchronize do
          # Re-check under the lock: another thread may have refreshed
          # while this one was waiting.
          refresh if tokens.expired?
          tokens.access_token
        end
      end

      # "Google" for Google-identity grants; nil for Microsoft.
      def identity_provider
        nil
      end

      private

      def refresh(refresh_token: nil)
        refresh_token ||= tokens&.refresh_token
        raise OAuthError, "no refresh token available" unless refresh_token

        request_tokens(
          "grant_type" => "refresh_token",
          "refresh_token" => refresh_token,
          "scope" => scope
        )
      end

      # Provider-specific hooks: the Microsoft grants substitute the
      # Azure AD tenant into these URLs; the Google grants replace the
      # endpoints and scope entirely.
      def authorize_url = AUTHORIZE_URL
      def token_url = TOKEN_URL
      def scope = SCOPE

      # Extra query params for the authorize URL (e.g. PKCE challenge).
      def authorization_extra_params = {}

      # Extra form params for token requests (e.g. client_secret, PKCE verifier).
      def token_extra_params = {}

      def request_tokens(params)
        uri = URI(token_url)
        form = { "client_id" => client_id }.merge(token_extra_params).merge(params)
        http = Net::HTTP.new(uri.hostname, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.open_timeout = 30
        http.read_timeout = 30
        request = Net::HTTP::Post.new(uri)
        request.form_data = form
        response = http.start { |h| h.request(request) }
        data = begin
          JSON.parse(response.body.to_s)
        rescue JSON::ParserError
          {}
        end

        unless response.is_a?(Net::HTTPSuccess)
          raise OAuthError.new(
            data["error_description"] || "token request failed (HTTP #{response.code})",
            code: data["error"], description: data["error_description"]
          )
        end

        @tokens = Tokens.new(
          access_token: data.fetch("access_token"),
          refresh_token: data["refresh_token"],
          expires_in: data["expires_in"],
          raw: data
        )
        @on_tokens_refreshed&.call(@tokens)
        @tokens
      end
    end
  end
end
