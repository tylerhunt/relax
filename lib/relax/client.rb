require 'faraday'

module Relax
  module Client
    USER_AGENT = "Relax Ruby Gem Client #{Relax::VERSION}"

    def self.included(base)
      base.extend(ClassMethods)

      base.parameter :adapter, default: Faraday.default_adapter
      base.parameter :base_uri
      base.parameter :user_agent, default: USER_AGENT
    end

    module ClassMethods
      attr :parameters

      def parameter(name, options={})
        attr(name, true)
        (@parameters ||= {})[name] = options
      end
    end

    def config
      @config ||= Config.build(self.class.parameters)
    end

    def configure
      yield(config)
      config
    end
  end
end
