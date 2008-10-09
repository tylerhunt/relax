require 'rubygems'
require 'hpricot'

require 'date'

module Relax
  # Response is intended to be a parent class for responses passed to
  # Service#call.
  #
  # A response is in essence an object used to facilitate XML parsing. It
  # stores an XML document, and provides access to it through methods like
  # #element and #attribute.
  class Response
    attr_accessor :raw
    attr_accessor :xml

    # New takes in the XML from the response. For the initial response, this
    # will be the root element, but child elements may also be passed into
    # Response objects.
    #
    # This will raise a MissingParameter error if a parameterd marked as
    # required is not present in the XML response.
    def initialize(xml)
      @raw = xml
      @xml = Hpricot.XML(xml.to_s)

      if parameters = self.class.instance_variable_get('@parameters')
        parameters.each do |parameter, options|
          begin
            element = options[:element] || parameter

            if attribute = options[:attribute] and attribute == true
              node = attribute(root, element)
            elsif attribute
              node = attribute(element(element), attribute)
            elsif options[:collection]
              node = elements(element)
            else
              node = element(element)
            end

            if options[:collection]
              value = node.collect do |element|
                options[:collection].new(element)
              end
            else
              case type = options[:type]
                when Response
                  value = type.new(node)

                when :date
                  value = date_value(node)

                when :time
                  value = time_value(node)

                when :float
                  value = float_value(node)

                when :integer
                  value = integer_value(node)

                when :text
                else
                  value = text_value(node)
              end
            end

            instance_variable_set("@#{parameter}", value)
          rescue Hpricot::Error
            raise MissingParameter if options[:required]
          end
        end
      end
    end

    # Returns the root of the XML document.
    def root
      @xml.root
    end

    # Checks the name of the root node.
    def is?(name)
      root.name.gsub(/.*:(.*)/, '\1') == node_name(name)
    end

    # Returns an element of the specified name.
    def element(name)
      root.at(root_path(name))
    end
    alias :has? :element

    # Returns an attribute on an element.
    def attribute(element, name)
      element[name]
    end

    # Returns a set of elements matching name.
    def elements(name)
      root.search(root_path(name))
    end

    # Gets the value of an element or attribute.
    def value(value)
      value.is_a?(Hpricot::Elem) ? value.inner_text : value.to_s
    end

    # Gets a text value.
    def text_value(value)
      value(value)
    end

    # Gets an integer value.
    def integer_value(value)
      value(value).to_i
    end

    # Gets a float value.
    def float_value(value)
      value(value).to_f
    end

    # Gets a date value.
    def date_value(value)
      Date.parse(value(value))
    end

    # Gets a time value.
    def time_value(value)
      Time.parse(value(value))
    end

    class << self
      # When a Response is extended, the superclass's parameters are copied
      # into the new class. This behavior has the following side-effect: if
      # parameters are added to the superclass after it has been extended,
      # those new paramters won't be passed on to its children. This shouldn't
      # be a problem in most cases.
      def inherited(subclass)
        @parameters.each do |name, options|
          subclass.parameter(name, options)
        end if @parameters
      end

      # Specifes a parameter that will be automatically parsed when the
      # Response is instantiated.
      #
      # Options:
      # - <tt>:attribute</tt>: An attribute name to use, or <tt>true</tt> to
      #   use the <tt>:element</tt> value as the attribute name on the root.
      # - <tt>:collection</tt>: A class used to instantiate each item when
      #   selecting a collection of elements.
      # - <tt>:element</tt>: The XML element name.
      # - <tt>:object</tt>: A class used to instantiate an element.
      # - <tt>:type</tt>: The type of the parameter. Should be one of
      #   <tt>:text</tt>, <tt>:integer</tt>, <tt>:float</tt>, or <tt>:date</tt>.
      def parameter(name, options = {})
        attr_accessor name
        @parameters ||= {}
        @parameters[name] = options
      end

      def ===(response)
        response.is_a?(Class) ? response.ancestors.include?(self) : super
      end
    end

    private

    # Converts a name to a node name.
    def node_name(name)
      name.to_s
    end

    # Gets the XPath expression representing the root node.
    def root_path(name)
      "/#{node_name(name)}"
    end
  end
end
