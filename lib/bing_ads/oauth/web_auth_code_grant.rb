# frozen_string_literal: true

module BingAds
  module OAuth
    # Microsoft authorization-code grant for confidential (server-side
    # web) apps.
    class WebAuthCodeGrant < Authorization
      attr_reader :client_secret, :tenant

      def initialize(client_id:, client_secret:, redirect_uri:, env: :production,
                     tenant: "common")
        super(client_id: client_id, redirect_uri: redirect_uri, env: env)
        @client_secret = client_secret
        @tenant = tenant
      end

      private

      # Azure AD tenant substitutes for "common" (mirrors the Python
      # SDK's tenant parameter).
      def authorize_url = AUTHORIZE_URL.sub("/common/", "/#{tenant}/")
      def token_url = TOKEN_URL.sub("/common/", "/#{tenant}/")

      def token_extra_params
        { "client_secret" => client_secret }
      end
    end
  end
end
