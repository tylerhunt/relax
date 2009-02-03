module Relax
  # SymbolicHash provides an extension of Hash, but one that only supports keys
  # that are symbols. This has been done in an effort to prevent the case where
  # both a string key and a symbol key are set on the same hash, and espcially
  # for dealing with this particular case when convert the hash to a string.
  #
  # === Example
  #
  #   hash = Relax::SymbolicHash.new
  #   hash[:one] = 1
  #   hash['one'] = 2
  #   puts hash[:one] # => 2
  #
  # === Credits
  #
  # Some of the inspiration (and code) for this class comes from the
  # HashWithIndifferentAccess that ships with Rails.
  class SymbolicHash < Hash
    def initialize(constructor = {})
      if constructor.is_a?(Hash)
        super()
        update(constructor)
      else
        super(constructor)
      end
    end

    def [](key)
      super(convert_key(key))
    end

    def []=(key, value)
      super(convert_key(key), convert_value(value))
    end

    def update(other_hash)
      other_hash.each_pair { |key, value| store(convert_key(key), convert_value(value)) }
      self
    end
    alias :merge! :update

    def fetch(key, *extras)
      super(convert_key(key), *extras)
    end

    def values_at(*indices)
      indices.collect { |key| self[convert_key(key)] }
    end

    def dup
      SymbolicHash.new(self)
    end

    def merge(hash)
      self.dup.update(hash)
    end

    def delete(key)
      super(convert_key(key))
    end

    def key?(key)
      super(convert_key(key))
    end
    alias :include? :key?
    alias :has_key? :key?
    alias :member? :key?

    def convert_key(key)
      !key.kind_of?(Symbol) ? key.to_sym : key
    end
    protected :convert_key

    def convert_value(value)
      value
    end
    protected :convert_value
  end
end
