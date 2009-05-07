module Relax
  class Action
    include Contextable

    attr_reader :name

    def initialize(endpoint, name, options, &block)
      @endpoint = endpoint
      @name = name
      @options = options

      extend_context(endpoint)
      context.evaluate(&block) if block_given?
    end

    def execute(values, credentials, *args)
      args.unshift(values) if values
      instance = Instance.new(*args)
      response = performer(instance, credentials).perform
      context.parse(response)
    end

    def method
      @options[:method] || :get
    end
    private :method

    def url
      [@endpoint.url, @options[:url]].join
    end
    private :url

    def performer(instance, credentials)
      values = instance.values(context)
      Performer.new(method, url, values, credentials)
    end
    private :performer
  end
end
