require 'relax/query'

module Relax
  # Request is intended to be a parent class for requests passed to
  # Service#call.
  class Request
    @parameters = {}

    # New takes an optional hash of default parameter values. When passed,
    # the values will be set on the request if the key exists as a valid
    # parameter name.
    def initialize(defaults={})
      # initialize default parameter values
      self.class.parameters.each do |parameter, options|
        if defaults.has_key?(parameter)
          value = defaults[parameter]
        elsif options[:value]
          value = options[:value]
        end

        instance_variable_set("@#{parameter}", value) if value
      end
    end

    # Converts this request into a Query object.
    def to_query
      self.class.parameters.keys.inject(Query.new) do |query, key|
        value = send(key)
        options = self.class.parameters[key]

        if value && !options[:type]
          query[convert_key(key)] = value if value
        elsif options[:type]
          options[:type].parameters.each do |parameter, options|
            query[convert_complex_key(key, parameter)] = value.send(parameter) if value
          end
        end

        query
      end
    end

    # Converts this request into a query string for use in a URL.
    def to_s
      to_query.to_s
    end

    # Checks the validity of the property values in this request.
    def valid?
      self.class.parameters.each do |key, options|
        if options[:required]
          value = send(key)
          raise Relax::MissingParameter if value.nil?
        end
      end
    end

    # Converts a key when the Request is converted to a query. By default, no
    # conversion actually takes place, but this method can be overridden by
    # child classes to perform standard manipulations, such as replacing
    # underscores.
    def convert_key(key)
      key
    end
    protected :convert_key

    # Converts a complex key (i.e. a parameter with a custom type) when the
    # Request is converted to a query. By default, this means the key name and
    # the parameter name separated by two underscores. This method can be
    # overridden by child classes.
    def convert_complex_key(key, parameter)
      "#{convert_key(key)}.#{convert_key(parameter)}"
    end
    protected :convert_complex_key

    class << self
      # Create the parameters hash for the subclass.
      def inherited(subclass) #:nodoc:
        subclass.instance_variable_set('@parameters', {})
      end

      # Specifies a parameter to create on the request class.
      #
      # Options:
      # - <tt>:type</tt>: An optional custom data type for the parameter.
      #   This must be a class that is a descendent of Request.
      # - <tt>:value</tt>: The default value for this parameter.
      def parameter(name, options = {})
        attr_accessor name
        options = @parameters[name].merge(options) if @parameters.has_key?(name)
        @parameters[name] = options
      end

      # Adds a template value to a request class. Equivalent to creating a
      # parameter with a default value.
      def []=(key, value)
        parameter(key, :value => value)
      end

      # Returns a hash of all of the parameters for this request, including
      # those that are inherited.
      def parameters #:nodoc:
        (superclass.respond_to?(:parameters) ? superclass.parameters : {}).merge(@parameters)
      end
    end
  end
end
