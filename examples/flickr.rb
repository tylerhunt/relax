# This example shows:
#
#   - overriding the default configuration values in Client#initialize
#   - extending the configuration with custom values using config.extend
#   - overriding Resource#get to merge in custom parameters
#   - customizing the resource to use JSON response parsing
#   - providing a module-level client accessor without using delegation

require 'relax'
require 'faraday_middleware'

module Flickr
  module Config
    attr :api_key, true
  end

  class Client
    include Relax::Client

    def initialize
      config.base_uri = 'http://api.flickr.com/services/rest/'
      config.extend(Config)
    end

    def search
      @search ||= Resources::Search.new(self)
    end
  end

  module Resource
    include Relax::Resource

    def get(method, parameters={})
      parameters.merge!(
        method: method,
        api_key: config.api_key,
        format: :json,
        nojsoncallback: 1
      )

      super(nil, parameters)
    end

    def connection
      super { |builder| builder.response(:json) }
    end
  end

  module Resources
    class Search
      include Resource

      def photos(tags)
        get('flickr.photos.search', tags: tags).body['photos']['photo']
      end
    end
  end

  def self.client
    @client ||= Client.new
  end
end

Flickr.client.configure do |config|
  config.api_key = ENV['FLICKR_API_KEY']
end

photos = Flickr.client.search.photos('ruby')

puts photos.first(10).collect { |photo| photo['title'] }
