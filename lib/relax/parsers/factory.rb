module Relax
  module Parsers
    # Manages the Relax::Parsers in the library.
    module Factory
      class << self
        # Returns the parser class which has been registered for the given
        # +name+.
        def get(name)
          @@parsers ||= {}
          @@parsers[name] || raise(UnrecognizedParser, "Given parser name not recognized: #{name.inspect}. Expected one of: #{@@parsers.keys.inspect}")
        end

        # Registers a new parser with the factory. The +name+ should be unique,
        # but if not, it will override the previously defined parser for the
        # given +name+.
        def register(name, klass)
          @@parsers ||= {}
          @@parsers[:default] = klass if @@parsers.empty?
          @@parsers[name] = klass
        end

        # Removes all registered parsers from the factory.
        def clear!
          @@parsers = {}
        end
      end
    end
  end
end
