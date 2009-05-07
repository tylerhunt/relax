module Relax
  class Performer
    def initialize(method, url, values, credentials)
      @method = method
      @url = url
      @values = values
      @credentials = credentials
    end

    def perform
      case @method
        when :delete, :get, :head then RestClient.send(@method, url)
        when :post, :put then RestClient.send(@method, url, query)
      end
    end

    def url
      uri = URI.parse(@url)
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
  end
end
