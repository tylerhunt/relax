module Relax
  class Parameter
    attr_reader :name, :options
    attr_writer :value

    def initialize(name, options={})
      @name = name
      @options = options
    end

    def named?(name)
      name == (@options[:as] || @name)
    end

    def value
      @value || @options[:default]
    end

    def required?
      @options[:required]
    end
  end
end
