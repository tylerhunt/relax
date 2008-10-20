module Relax
  # Response is intended to be a parent class for responses passed to
  # Service#call.
  #
  # A response is in essence an object used to facilitate XML parsing. It
  # stores an XML document, and provides access to it through methods like
  # #element and #attribute.
  class Response
    attr_accessor :raw
    
    # New takes in and parses the raw response.
    #
    # This will raise a MissingParameter error if a parameterd marked as
    # required is not present in the parsed response.
    def initialize(xml)
      @raw    = xml
      @parser = Relax::Parsers::Hpricot.new(xml.to_s, self)
    end
    
    def method_missing(method, *args) #:nodoc:
      if @parser.respond_to?(method)
        @parser.__send__(method, *args)
      else
        super
      end
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

  end
end
