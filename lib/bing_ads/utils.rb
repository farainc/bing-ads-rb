# frozen_string_literal: true

module BingAds
  module Utils
    module_function

    def camelize(key)
      key.to_s.split("_").map { |part| BingAds.acronyms.fetch(part) { part.capitalize } }.join
    end

    def camelize_keys(value)
      case value
      when Hash
        value.each_with_object({}) do |(k, v), out|
          out[k.is_a?(Symbol) ? camelize(k) : k] = camelize_keys(v)
        end
      when Array
        value.map { |v| camelize_keys(v) }
      else
        value
      end
    end

    def underscore(key)
      key.to_s
         .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
         .gsub(/([a-z\d])([A-Z])/, '\1_\2')
         .downcase
    end

    # Normalizes a "flags enum" value (e.g. +CampaignType+, +ConversionGoalTypes+,
    # +CriterionType+, +DataScope+, any +*AdditionalField+/+ReturnAdditionalFields+
    # parameter) into the comma-joined string the REST API actually accepts.
    #
    # The SOAP API historically documented — and the v13 REST API's own SDKs/docs
    # still show — flags enums as a space-separated string, e.g.
    # <tt>"Url Duration Event"</tt>. Verified live against the production v13 REST
    # API (2026-08-31): a space-joined string, and likewise a plain Array, fail
    # request deserialization entirely with <tt>100 NullRequest "The request
    # message is null"</tt> — a response that gives no hint the flags value was
    # the problem. Only a comma-joined string (e.g. <tt>"Url,Duration,Event"</tt>)
    # is accepted. This normalizes any of the documented-but-broken forms (Array,
    # space-separated String, or mixed) into the one form the wire protocol
    # actually understands, so callers can keep using the SOAP-style syntax from
    # older documentation and it just works.
    #
    # +nil+ passes through unchanged (so callers can safely +.compact+ afterward).
    # An Array has its elements stringified and comma-joined. A String is split on
    # commas and/or whitespace (blanks dropped) and re-joined with commas — this
    # also normalizes an already-comma-joined string and a single bare value.
    # Anything else is coerced with +#to_s+.
    def flags(value)
      case value
      when nil
        nil
      when Array
        value.join(",")
      when String
        value.split(/[,\s]+/).reject(&:empty?).join(",")
      else
        value.to_s
      end
    end
  end
end
