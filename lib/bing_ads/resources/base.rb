# frozen_string_literal: true

module BingAds
  module Resources
    # Abstract base class for all resource classes. Provides HTTP verb helpers
    # (+post+, +put+, +delete+) that camelize request keys and wrap responses in
    # +BingAds::Object+.
    class Base
      class << self
        # Declares (or reads) the service this resource belongs to,
        # e.g. `service :campaign_management`.
        def service(name = nil)
          @service = name if name
          @service || (superclass.respond_to?(:service) ? superclass.service : nil)
        end
      end

      # +client+:: A +BingAds::Client+ instance whose credentials are used for every request.
      def initialize(client)
        @client = client
      end

      private

      attr_reader :client

      # Issues a POST request to +path+ with +body+ camelized as JSON.
      #
      # Returns a +BingAds::Object+ wrapping the parsed response.
      def post(path, body = nil, **)
        request(:post, path, body, **)
      end

      # Issues a PUT request to +path+ with +body+ camelized as JSON.
      #
      # Returns a +BingAds::Object+ wrapping the parsed response.
      def put(path, body = nil, **)
        request(:put, path, body, **)
      end

      # Issues a DELETE request to +path+ with +body+ camelized as JSON.
      #
      # Returns a +BingAds::Object+ wrapping the parsed response, or nil on empty body.
      def delete(path, body = nil, **)
        request(:delete, path, body, **)
      end

      # Executes an HTTP +method+ request against the resource's declared service.
      #
      # +method+:: HTTP verb symbol (+:post+, +:put+, +:delete+).
      # +path+:: Service-relative path, e.g. <tt>"/Campaigns"</tt>.
      # +body+:: Optional. Ruby hash with snake_case keys; keys are camelized before sending.
      # +customer_id+:: Optional. Override the customer ID header for this request.
      # +account_id+:: Optional. Override the account ID header for this request.
      #
      # Returns a +BingAds::Object+ wrapping the parsed response, or nil on empty body.
      def request(method, path, body, customer_id: nil, account_id: nil)
        raise Error, "#{self.class.name} must declare `service :name`" unless self.class.service

        payload = body.nil? ? nil : Utils.camelize_keys(body)
        data = client.execute(service: self.class.service, method: method, path: path,
                              body: payload, customer_id: customer_id, account_id: account_id)
        Object.wrap(data)
      end
    end
  end
end
