# frozen_string_literal: true

module BingAds
  module OAuth
    # Google-identity grant for public clients. Google has no
    # equivalent of Microsoft's nativeclient redirect URI, so
    # redirect_uri is required (typically a localhost loopback).
    class GoogleDesktopMobileAuthCodeGrant < DesktopMobileAuthCodeGrant
      AUTHORIZE_URL = "https://accounts.google.com/o/oauth2/v2/auth"
      TOKEN_URL = "https://oauth2.googleapis.com/token"
      SCOPE = "openid email profile"

      # Loopback redirect for installed apps (Python SDK default).
      DEFAULT_REDIRECT_URI = "http://localhost"

      def initialize(client_id:, redirect_uri: DEFAULT_REDIRECT_URI,
                     env: :production, pkce: true)
        super
      end

      def identity_provider
        "Google"
      end

      private

      def authorize_url = AUTHORIZE_URL
      def token_url = TOKEN_URL
      def scope = SCOPE

      def authorization_extra_params
        super.merge("access_type" => "offline", "prompt" => "consent")
      end
    end
  end
end
