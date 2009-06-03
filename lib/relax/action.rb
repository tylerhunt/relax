module Relax
  class Action
    include Contextable

    attr_reader :name

    def initialize(endpoint, name, options, &block)
      @endpoint = endpoint
      @name = name
      @options = options

      extend_context(endpoint)
      parse_url_parameters
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

    def parse_url_parameters
      url.scan(/(?:\:)([a-z_]+)/).flatten.each do |name|
        defaults do
          parameter name.to_sym, :required => true
        end
      end
    end
    private :parse_url_parameters
  end
end
