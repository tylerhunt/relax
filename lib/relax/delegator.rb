module Relax
  module Delegator
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
