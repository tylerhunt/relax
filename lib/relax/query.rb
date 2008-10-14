require 'erb'
require 'uri'

require 'relax/symbolic_hash'

module Relax
  # Query is used to represent the query portion of a URL. It's basically just
  # a hash, where each key/value pair is a query parameter.
  class Query < SymbolicHash
    # Converts the Query to a query string for use in a URL.
    def to_s
      keys.sort { |a, b| a.to_s <=> b.to_s }.collect do |key|
        "#{key.to_s}=#{self.class.escape_value(fetch(key))}"
      end.join('&')
    end

    class << self
      # Parses a URL and returns a Query with its query portion.
      def parse(uri)
        query = uri.query.split('&').inject({}) do |query, parameter|
          key, value = parameter.split('=')
          query[key] = unescape_value(value)
          query
        end
        self.new(query)
      end

      # Escapes a query parameter value.
      def escape_value(value)
        ERB::Util.url_encode(value.to_s).gsub('%20', '+')
      end

      # Unescapes a query parameter value.
      def unescape_value(value)
        URI.unescape(value.gsub('+', '%20'))
      end
    end

    protected

    # Converts each value of the Query to a string as it's added.
    def convert_value(value)
      value.to_s
    end
  end
end
