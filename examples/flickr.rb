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
      super do |builder|
        builder.response(:json)
      end
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

  include Relax::Delegator

  delegate_to Client
end

Flickr.configure do |config|
  config.api_key = ENV['FLICKR_API_KEY']
end

photos = Flickr.search.photos('ruby')

puts photos.first(10).collect { |photo| photo['title'] }
