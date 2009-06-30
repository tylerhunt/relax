module Relax
  class Context
    attr_reader :parameters

    def initialize(parameters=[]) # :nodoc:
      @parameters = parameters
    end

    def evaluate(&block) # :nodoc:
      instance_eval(&block)
    end

    def parameter(name, options={})
      unless @parameters.find { |parameter| parameter.named?(name) }
        @parameters << Parameter.new(name, options)
      else
        raise ArgumentError.new("Duplicate parameter '#{name}'.")
      end
    end

    def set(name, value)
      if parameter = @parameters.find { |parameter| parameter.named?(name) }
        parameter.value = value
      end
    end

    def parser(root, options={}, &block) # :nodoc:
      @parser ||= begin
        if root.kind_of?(Class)
          root.new(options, &block)
        else
          Relief::Parser.new(root, options, &block)
        end
      end
    end

    def parse(response) # :nodoc:
      @parser.parse(response)
    end

    def clone # :nodoc:
      cloned_parameters = @parameters.collect { |parameter| parameter.clone }
      self.class.new(cloned_parameters)
    end
  end
end
