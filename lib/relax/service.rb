module Relax
  class Service
    def initialize(values={}, options={})
      @values = values
      @options = options
    end

    def authenticate(*args)
      @options[:credentials] = args
      self
    end

    def proxy(url)
      @options[:proxy] = url
      self
    end

    def include_blank_values(value)
      @options[:include_blank_values] = value
      self
    end

    class << self
      include Contextable

      def endpoint(url, options={}, &block)
        Endpoint.new(self, url, options, &block)
      end

      def register_action(action) # :nodoc:
        @actions ||= {}

        unless @actions[action.name]
          @actions[action.name] = action.name

          define_method(action.name) do |*args|
            action.execute(@values, @options, *args)
          end
        else
          raise ArgumentError.new("Duplicate action '#{action.name}'.") 
        end
      end
    end
  end
end
