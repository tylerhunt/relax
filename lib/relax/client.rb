require 'faraday'

module Relax
  module Client
    USER_AGENT = "Relax Ruby Gem Client #{Relax::VERSION}"
    TIMEOUT = 60

    def config
      @config ||= Config.new.configure do |config|
        config.adapter = Faraday.default_adapter
        config.user_agent = USER_AGENT
        config.timeout = TIMEOUT
      end
    end

    def configure(&block)
      config.configure(&block)
    end
  end
end
