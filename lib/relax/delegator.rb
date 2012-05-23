module Relax
  module Delegator
    def self.[](client_method)
      Module.new do
        include ClassMethods

        define_method(:client_instance) { send(client_method) }
      end
    end

    module ClassMethods
      def respond_to?(method, include_private=false)
        super || client_instance.respond_to?(method, include_private)
      end

      def method_missing(method, *args, &block)
        if client_instance.respond_to?(method)
          client_instance.send(method, *args, &block)
        else
          super
        end
      end
    end
  end
end
