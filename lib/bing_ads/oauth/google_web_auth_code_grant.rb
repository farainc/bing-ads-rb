# frozen_string_literal: true

module BingAds
  module OAuth
    class GoogleWebAuthCodeGrant < WebAuthCodeGrant
      AUTHORIZE_URL = "https://accounts.google.com/o/oauth2/v2/auth"
      TOKEN_URL = "https://oauth2.googleapis.com/token"
      SCOPE = "openid email profile"

      def identity_provider
        "Google"
      end

      private

      def authorize_url = AUTHORIZE_URL
      def token_url = TOKEN_URL
      def scope = SCOPE

      def authorization_extra_params
        { "access_type" => "offline", "prompt" => "consent" }
      end
    end
  end
end
