module Relax
  module Client
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr :configurator

      def configure_with(configurator)
        @configurator = configurator
      end
    end

    def config
      @config ||= self.class.configurator.new
    end

    def configure
      yield(config)
      config
    end
  end
end
