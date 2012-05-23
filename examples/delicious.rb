require 'relax'
require 'multi_xml'
require 'faraday_middleware'

module Delicious
  class Client
    include Relax::Client

    parameter :base_uri, default: 'https://api.del.icio.us/v1'
    parameter :username
    parameter :password

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

  include Relax::Delegator

  delegate_to Client
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
