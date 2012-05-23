module Relax
  class Config
    attr :adapter, true
    attr :base_uri, true
    attr :user_agent, true

    def configure
      yield(self)
      self
    end
  end
end
