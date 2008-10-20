module Relax
  module Parsers
    
    module Factory
      
      class << self
        
        def get(name)
          @@parsers ||= {}
          @@parsers[name] || raise(UnrecognizedParser, "Given parser name not recognized: #{name.inspect}.  Expected one of: #{@@parsers.keys.inspect}")
        end
      
        def register(name, klass)
          @@parsers ||= {}
          @@parsers[:default] = klass if @@parsers.empty?
          @@parsers[name] = klass
        end
        
        def clear!
          @@parsers = {}
        end
        
      end
      
    end
    
  end
end
