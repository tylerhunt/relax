# This example shows:
#
#   - inheriting from Relax::Config and overriding Client#config to use it
#   - customizing the resource to use basic auth and XML response parsing
#   - instantiating multiple clients with distinct configurations
#   - modifying a client instance endpoint to point to a different API

require 'relax'
require 'multi_xml'
require 'faraday_middleware'

module Delicious
  class Config < Relax::Config
    attr :username, true
    attr :password, true

    def initialize
      super
      self.base_uri = 'https://api.del.icio.us/v1'
    end
  end

  class Client
    include Relax::Client

    def config
      @config ||= Config.new
    end

    def posts
      @posts ||= Resources::Posts.new(self)
    end
  end

  module Resource
    include Relax::Resource

    def connection
      super do |builder|
        builder.basic_auth(config.username, config.password)
        builder.response(:xml)
      end
    end
  end

  module Resources
    class Posts
      include Resource

      def recent(params={})
        get('posts/recent', params).body['posts']['post']
      end
    end
  end
end

delicious = Delicious::Client.new
pinboard = Delicious::Client.new

delicious.configure do |config|
  config.username = ENV['DELICIOUS_USERNAME']
  config.password = ENV['DELICIOUS_PASSWORD']
end

pinboard.configure do |config|
  config.base_uri = 'https://api.pinboard.in/v1'
  config.username = ENV['PINBOARD_USERNAME']
  config.password = ENV['PINBOARD_PASSWORD']
end

puts delicious.posts.recent.first(10).collect { |post| post['href'] }
puts pinboard.posts.recent.first(10).collect { |post| post['href'] }
