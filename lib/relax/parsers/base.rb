module Relax
  module Parsers
    
    class Base
      
      attr_reader :parent
      attr_reader :parameters
      
      def initialize(raw, parent)
        @parent     = parent
        @parameters = parent.class.instance_variable_get('@parameters')
        parse!
      end
      
      def parse!; end
      
      def root; end
      def is?(name); end
      def has?(name); end
      def element(name); end
      def elements(name); end
      
      def attribute(element, name); end
      def value(value); end
      def text_value(value); end
      def integer_value(value); end
      def float_value(value); end
      def date_value(value); end
      def time_value(value); end
      
    end
    
  end
end
