require 'faraday'

module Relax
  module Config
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

    def initialize
      self.class.parameters.each do |name, options|
        if default = options[:default]
          send(:"#{name}=", default)
        end
      end if self.class.parameters
    end
  end
end
