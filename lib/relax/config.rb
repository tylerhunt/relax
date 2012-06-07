require 'faraday'

module Relax
  class Config
    USER_AGENT = "Relax Ruby Gem Client #{Relax::VERSION}"
    TIMEOUT = 60

    attr :adapter, true
    attr :base_uri, true
    attr :timeout, true
    attr :user_agent, true

    def initialize
      self.adapter = Faraday.default_adapter
      self.user_agent = USER_AGENT
      self.timeout = TIMEOUT
    end
  end
end
