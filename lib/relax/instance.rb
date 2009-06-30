module Relax
  class Instance # :nodoc:
    def initialize(*args)
      @values = args.inject({}) do |values, arg|
        arg.is_a?(Hash) ? values.merge(arg) : values
      end
    end

    def values(context)
      context.parameters.inject({}) do |values, parameter|
        name = parameter.options[:as] || parameter.name

        if value = @values[name] || parameter.value
          values[parameter.name] = value
        elsif parameter.required?
          raise ArgumentError.new("Missing value for '#{name}'.")
        end

        values
      end
    end
  end
end
