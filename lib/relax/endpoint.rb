module Relax
  class Endpoint
    include Contextable

    attr_reader :url

    def initialize(service, url, options, &block)
      @service = service
      @url = url
      @options = options

      extend_context(service)
      instance_eval(&block)
    end

    def action(name, options={}, &block)
      action = Action.new(self, name, options, &block)
      @service.register_action(action)
    end
  end
end
