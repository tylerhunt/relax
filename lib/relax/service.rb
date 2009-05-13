module Relax
  class Service
    def initialize(values={})
      @values = values
    end

    def authenticate(*args)
      @credentials = args
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
            action.execute(@values, @credentials, *args)
          end
        else
          raise ArgumentError.new("Duplicate action '#{action.name}'.") 
        end
      end
    end
  end
end
