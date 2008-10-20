require 'rubygems'
require 'hpricot'

module Relax
  module Parsers
    
    class Hpricot < Base
      
      def initialize(raw, parent)
        @xml = ::Hpricot.XML(raw)
        super(raw, parent)
      end
      
      def parse!
        if parameters
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

              parent.instance_variable_set("@#{parameter}", value)
            rescue ::Hpricot::Error
              raise Relax::MissingParameter if options[:required]
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
      
      # Returns a set of elements matching name.
      def elements(name)
        root.search(root_path(name))
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

      # Gets the value of an element or attribute.
      def value(value)
        value.is_a?(::Hpricot::Elem) ? value.inner_text : value.to_s
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
    
    Factory.register(:hpricot, Hpricot)
    
  end
end
