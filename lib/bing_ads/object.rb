# frozen_string_literal: true

module BingAds
  # Wraps parsed JSON responses. PascalCase keys are readable as
  # snake_case methods; raw data stays available via #[] and #to_h.
  class Object
    def self.wrap(value)
      case value
      when ::Hash then new(value)
      when ::Array then value.map { |v| wrap(v) }
      else value
      end
    end

    def initialize(data)
      @data = data
      @lookup = data.keys.grep(::String).to_h { |k| [Utils.underscore(k), k] }
    end

    def [](key)
      @data[key]
    end

    def key?(key)
      @data.key?(key)
    end

    def to_h
      @data
    end

    def ==(other)
      other.is_a?(self.class) && to_h == other.to_h
    end

    def inspect
      "#<#{self.class.name} #{@data.inspect}>"
    end

    private

    def method_missing(name, *args, **kwargs)
      key = lookup_key(name)
      return super if key.nil? || !args.empty? || !kwargs.empty?

      self.class.wrap(@data[key])
    end

    def respond_to_missing?(name, include_private = false)
      !lookup_key(name).nil? || super
    end

    def lookup_key(name)
      @lookup[name.to_s]
    end
  end
end
