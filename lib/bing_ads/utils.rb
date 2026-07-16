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
  end
end
