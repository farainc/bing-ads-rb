# frozen_string_literal: true

require "net/http"
require "net/http/persistent"
require "json"
require "uri"
require "openssl"
require "fileutils"

module BingAds
  class Connection
    # Low-level failures wrapped as BingAds::NetworkError.
    NETWORK_EXCEPTIONS = [
      Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Net::OpenTimeout, SocketError,
      Net::ReadTimeout, Errno::ECONNRESET, Errno::EPIPE, EOFError, IOError,
      OpenSSL::SSL::SSLError, Net::HTTP::Persistent::Error
    ].freeze

    HTTP_METHODS = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      delete: Net::HTTP::Delete,
      patch: Net::HTTP::Patch
    }.freeze

    USER_AGENT = "bing-ads/#{BingAds::VERSION} (ruby/#{RUBY_VERSION})".freeze

    attr_reader :options

    def initialize(**options)
      @logger = options.delete(:logger)
      @max_retries = options.delete(:max_retries) || 3
      @sleeper = options.delete(:sleeper) || ->(seconds) { sleep(seconds) }
      @options = options
      @http = build_http
    end

    # Performs an HTTP request with JSON body/response. Failures are
    # mapped to typed errors first; the retry loop is then driven by
    # Error#retryable? and Error#retry_after.
    def request(method, url, headers: {}, body: nil)
      uri = URI(url)
      attempt = 1
      begin
        handle(perform(method, uri, headers, body))
      rescue Error => e
        raise unless retryable?(e, attempt)

        wait(attempt, e.retry_after)
        attempt += 1
        retry
      end
    end

    # Downloads a URL (e.g. a Reporting/Bulk result file), streaming in
    # chunks (constant memory). Two forms:
    #
    #   download(url, to: "path")           # stream to a file, returns the path
    #   download(url) { |chunk| ... }       # yield each chunk, returns total bytes
    #
    # The file form writes to "<to>.part" and renames only once the
    # download completed, so a failed attempt never leaves a truncated
    # file, and failures retry like #request. The block form stops
    # retrying once the first chunk has been yielded — the block may
    # already have processed partial data.
    def download(url, to: nil, &block)
      raise ArgumentError, "provide either to: or a block, not both" if to && block
      raise ArgumentError, "provide a destination path (to:) or a block" unless to || block

      uri = URI(url)
      attempt = 1
      delivered = false
      begin
        if block
          stream_chunks(uri) do |chunk|
            delivered = true
            block.call(chunk)
          end
        else
          stream_to_file(uri, to)
          to
        end
      rescue Error => e
        raise if delivered || !retryable?(e, attempt)

        wait(attempt, e.retry_after)
        attempt += 1
        retry
      end
    end

    # Closes pooled connections for the calling thread.
    def shutdown
      @http.shutdown
    end

    private

    def build_http
      Net::HTTP::Persistent.new(name: "bing-ads").tap do |http|
        http.open_timeout = options[:open_timeout] || 30
        http.read_timeout = options[:read_timeout] || 100
      end
    end

    def perform(method, uri, headers, body)
      request_class = HTTP_METHODS.fetch(method.to_sym) do
        raise ArgumentError, "unsupported HTTP method: #{method.inspect}"
      end
      request = request_class.new(uri)
      request["User-Agent"] = USER_AGENT
      headers.each { |key, value| request[key] = value }
      unless body.nil?
        request["Content-Type"] = "application/json"
        request.body = JSON.generate(body)
      end
      @logger&.info("bing-ads: #{method.to_s.upcase} #{uri}")
      @http.request(uri, request)
    rescue *NETWORK_EXCEPTIONS => e
      raise NetworkError, "#{e.class}: #{e.message}"
    end

    def stream_to_file(uri, to)
      partial = "#{to}.part"
      File.open(partial, "wb") do |file|
        stream_chunks(uri) { |chunk| file.write(chunk) }
      end
      File.rename(partial, to)
    ensure
      FileUtils.rm_f(partial)
    end

    # Yields each body chunk as it arrives; returns the total bytes.
    def stream_chunks(uri)
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = USER_AGENT
      @logger&.info("bing-ads: GET #{uri}")
      bytes = 0
      @http.request(uri, request) do |response|
        unless (200..299).cover?(response.code.to_i)
          # Consume the (small) error body so the pooled connection
          # stays reusable, then surface the typed error.
          response.body
          raise HTTPError.from_response(response)
        end

        response.read_body do |chunk|
          bytes += chunk.bytesize
          yield chunk
        end
      end
      bytes
    rescue *NETWORK_EXCEPTIONS => e
      raise NetworkError, "#{e.class}: #{e.message}"
    end

    def handle(response)
      status = response.code.to_i
      raise HTTPError.from_response(response) unless (200..299).cover?(status)

      body = response.body.to_s
      return if body.empty?

      JSON.parse(body)
    end

    def retryable?(error, attempt)
      attempt <= @max_retries && error.retryable?
    end

    def wait(attempt, retry_after)
      seconds = retry_after || ((2**(attempt - 1)) + rand)
      @sleeper.call(seconds)
    end
  end
end
