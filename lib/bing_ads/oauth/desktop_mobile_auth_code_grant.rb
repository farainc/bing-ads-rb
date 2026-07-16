# frozen_string_literal: true

require "securerandom"
require "digest"
require "base64"

module BingAds
  module OAuth
    # Microsoft authorization-code grant for public (native/desktop)
    # apps. No client secret; PKCE (S256) is on by default.
    class DesktopMobileAuthCodeGrant < Authorization
      NATIVE_REDIRECT_URI = "https://login.microsoftonline.com/common/oauth2/nativeclient"

      attr_reader :code_verifier, :tenant

      def initialize(client_id:, redirect_uri: NATIVE_REDIRECT_URI,
                     env: :production, pkce: true, tenant: "common")
        super(client_id: client_id, redirect_uri: redirect_uri, env: env)
        @code_verifier = pkce ? SecureRandom.urlsafe_base64(64) : nil
        @tenant = tenant
      end

      private

      # Azure AD tenant substitutes for "common" (mirrors the Python
      # SDK's tenant parameter). The Google subclass replaces these
      # endpoints entirely, so the substitution never applies there.
      def authorize_url = AUTHORIZE_URL.sub("/common/", "/#{tenant}/")
      def token_url = TOKEN_URL.sub("/common/", "/#{tenant}/")

      def authorization_extra_params
        return {} unless code_verifier

        challenge = Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier), padding: false)
        { "code_challenge" => challenge, "code_challenge_method" => "S256" }
      end

      def token_extra_params
        code_verifier ? { "code_verifier" => code_verifier } : {}
      end
    end
  end
end
