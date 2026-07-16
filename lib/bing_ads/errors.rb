# frozen_string_literal: true

require "json"
require "time"

module BingAds
  class Error < StandardError
    # @return [Boolean] whether the operation can be retried
    attr_reader :retryable

    # @return [Integer, nil] seconds to wait before retrying (for rate limits)
    attr_reader :retry_after

    def initialize(message = nil, retryable: false, retry_after: nil)
      super(message)
      @retryable = retryable
      @retry_after = retry_after
    end

    alias retryable? retryable
  end

  class OAuthError < Error
    attr_reader :code, :description

    def initialize(message = nil, code: nil, description: nil, **)
      super(message, **)
      @code = code
      @description = description
    end
  end

  # Raised when an async Reporting/Bulk operation reaches a terminal
  # failure status (e.g. "Error", "Failed", "FailedFullSyncRequired").
  class OperationFailedError < Error
    attr_reader :status, :errors

    def initialize(message = nil, status:, errors: nil, **)
      super(message, **)
      @status = status
      @errors = errors
    end
  end

  # Raised when there's a network error (connection refused, timeouts, DNS TLS failures).
  # The original exception is available on #cause.
  class NetworkError < Error
    def initialize(message = nil, retryable: true, **)
      super
    end
  end

  class HTTPError < Error
    # Upper bound on server-provided Retry-After waits.
    MAX_RETRY_AFTER = 300

    # @return [String, nil] TrackingId from the response — Microsoft
    # Advertising's correlation id for support escalations.
    attr_reader :tracking_id

    attr_reader :status, :code, :errors, :body

    def initialize(message = nil, status:, code: nil, errors: nil, body: nil,
                   tracking_id: nil, **)
      super(message, **)
      @status = status
      @code = code
      @errors = errors || []
      @body = body
      @tracking_id = tracking_id
    end

    def self.from_response(response)
      status = response.code.to_i
      parsed = begin
        JSON.parse(response.body.to_s)
      rescue JSON::ParserError
        nil
      end
      errors = extract_errors(parsed)
      first = errors.first || {}
      klass = case status
              when 400, 422 then ValidationError
              when 401 then AuthenticationError
              when 403 then ForbiddenError
              when 404 then NotFoundError
              when 429 then RateLimitError
              when 500..599 then ServerError
              else HTTPError
              end
      klass.new(
        first["Message"] || "HTTP #{status}",
        status: status,
        code: first["Code"],
        errors: errors,
        body: parsed,
        tracking_id: response["TrackingId"],
        retry_after: parse_retry_after(response["Retry-After"])
      )
    end

    # Parses a Retry-After header (integer seconds or HTTP-date) into
    # seconds, capped at MAX_RETRY_AFTER. Returns nil when absent or
    # invalid — including fractional seconds, which RFC 7231 disallows.
    def self.parse_retry_after(value)
      return if value.nil? || value.to_s.empty?

      seconds = Integer(value, exception: false)
      seconds ||= begin
        (Time.httpdate(value) - Time.now).ceil
      rescue ArgumentError
        nil
      end
      return unless seconds&.positive?

      [seconds, MAX_RETRY_AFTER].min
    end

    def self.extract_errors(body)
      return [] unless body.is_a?(Hash)

      %w[OperationErrors Errors BatchErrors].each do |key|
        value = body[key]
        return value if value.is_a?(Array)
      end
      %w[AdApiFaultDetail ApiFaultDetail ApplicationFault].each do |key|
        nested = extract_errors(body[key])
        return nested unless nested.empty?
      end
      []
    end
  end

  class AuthenticationError < HTTPError; end
  class ForbiddenError < HTTPError; end
  class NotFoundError < HTTPError; end
  class ValidationError < HTTPError; end

  class RateLimitError < HTTPError
    def initialize(message = nil, retryable: true, **options)
      super
    end
  end

  class ServerError < HTTPError
    def initialize(message = nil, retryable: true, **options)
      super
    end
  end
end
