module Relax
  class Performer
    def initialize(method, url, values, credentials)
      @method = method
      @url = url
      @values = values
      @credentials = credentials

      parse_url_tokens
    end

    def perform
      case @method
        when :delete, :get, :head then RestClient.send(@method, url)
        when :post, :put then RestClient.send(@method, url, query)
      end
    end

    def url
      url = @url.gsub(/\:[a-z_]+/) do |name|
        @url_values[name[1..-1].to_sym]
      end

      uri = URI.parse(url)
      uri.query = query unless query.nil? || query.empty?
      uri.userinfo = @credentials.join(':') if @credentials
      uri.to_s
    end
    private :url

    def query
      @values.collect do |name, value|
        "#{name}=#{value}" if value
      end.compact.join('&')
    end
    private :query

    def parse_url_tokens
      @url_values = @url.scan(/(?:\:)([a-z_]+)/).flatten.inject({}) do |values, name|
        name = name.to_sym
        values[name] = @values.delete(name) if @values.key?(name)
        values
      end
    end
    private :parse_url_tokens
  end
end
