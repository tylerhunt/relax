module Relax
  class Endpoint
    include Contextable

    attr_reader :url

    def initialize(service, url, options, &block)
      @service = service
      @url = url
      @options = options

      extend_context(service)
      parse_url_parameters
      instance_eval(&block)
    end

    def action(name, options={}, &block)
      action = Action.new(self, name, options, &block)
      @service.register_action(action)
    end

    def parse_url_parameters
      @url.scan(/(?:\:)([a-z_]+)/).flatten.each do |name|
        defaults do
          parameter name.to_sym, :required => true
        end
      end
    end
    private :parse_url_parameters
  end
end
