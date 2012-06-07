module Relax
  module Configurable
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
      self
    end
  end
end
