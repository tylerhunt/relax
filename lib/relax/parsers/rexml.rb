require 'rubygems'
require 'rexml/document'

module Relax
  module Parsers
    # Parsers the server's response using the REXML library.
    #
    # Benefits:
    #
    # * XML Namespace support (parameter :foo, :namespace => 'bar')
    #
    # Drawbacks:
    #
    # * Case sensitive field names (<Status>..</> != parameter :status)
    class REXML < Base
      FACTORY_NAME = :rexml

      def initialize(raw, parent)
        @xml = ::REXML::Document.new(raw)
        super(raw, parent)
      end

      def parse!
        if parameters
          parameters.each do |parameter, options|
            begin
              element = options[:element] || parameter
              namespace = options[:namespace]

              if attribute = options[:attribute] and attribute == true
                node = attribute(root, element, namespace)
              elsif attribute
                node = attribute(element(element), attribute, namespace)
              elsif options[:collection]
                node = elements(element, namespace)
              else
                node = element(element, namespace)
              end

              if options[:collection]
                value = node.collect do |element|
                  options[:collection].new(element.deep_clone)
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
            rescue
              raise(Relax::MissingParameter) if node.nil? && options[:required]
            end
          end
        end
      end

      # Returns the root of the XML document.
      def root
        @xml.root
      end

      # Checks the name of the root node.
      def is?(name, namespace = nil)
        root.name == node_name(name, nil)
      end

      # Returns a set of elements matching name.
      def elements(name, namespace = nil)
        root.get_elements(node_path(name, namespace))
      end

      # Returns an element of the specified name.
      def element(name, namespace = nil)
        root.elements[node_path(name, namespace)]
      end
      alias :has? :element

      # Returns an attribute on an element.
      def attribute(element, name, namespace = nil)
        element.attribute(name)
      end

      # Gets the value of an element or attribute.
      def value(value)
        value.is_a?(::REXML::Element) ? value.text : value.to_s
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

      # Converts a name to a node name.
      def node_name(name, namespace = nil)
        "#{namespace.to_s + ':' if namespace}#{name}"
      end
      private :node_name

      # Gets the XPath expression representing the root node.
      def root_path(name)
        "/#{node_name(name)}"
      end
      private :root_path

      def node_path(name, namespace = nil)
        "#{node_name(name, namespace)}"
      end
      private :node_path
    end

    Factory.register(REXML::FACTORY_NAME, REXML)
  end
end
