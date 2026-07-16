# frozen_string_literal: true

module BingAds
  module OAuth
    # Immutable value object for an OAuth token set.
    Tokens = Data.define(:access_token, :refresh_token, :expires_in, :issued_at, :raw) do
      def initialize(access_token:, refresh_token: nil, expires_in: nil,
                     issued_at: nil, raw: {})
        super(access_token: access_token, refresh_token: refresh_token,
              expires_in: expires_in, issued_at: issued_at || Time.now, raw: raw)
      end

      def expires_at
        return unless expires_in

        issued_at + Integer(expires_in)
      end

      def expired?(leeway: 300)
        return false unless expires_at

        Time.now >= expires_at - leeway
      end

      # Never leak token values into logs (Data's default inspect would).
      def inspect
        "#<#{self.class.name} access_token=[REDACTED] " \
          "refresh_token=#{refresh_token ? "[REDACTED]" : "nil"} " \
          "expires_at=#{expires_at.inspect}>"
      end
    end
  end
end
