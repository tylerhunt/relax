module Relax
  module Delegator
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr :client
      private :client

      def delegate_to(client)
        @client = client.new
      end

      def respond_to?(method, include_private=false)
        super || client.respond_to?(method, include_private)
      end

      def method_missing(method, *args, &block)
        if client.respond_to?(method)
          client.send(method, *args, &block)
        else
          super
        end
      end
    end
  end
end
