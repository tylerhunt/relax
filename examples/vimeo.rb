require 'relax'
require 'faraday_middleware'

module Vimeo
  extend Relax::Delegator[:client]

  class Client
    include Relax::Client

    def initialize
      config.base_uri = 'http://vimeo.com/api/v2'
    end

    def user(username)
      Resources::User.new(self, username: username)
    end
  end

  module Resource
    include Relax::Resource

    def connection
      super { |builder| builder.response(:json) }
    end
  end

  module Resources
    class User
      include Resource

      def info
        get("#{@options[:username]}/info.json").body
      end

      def videos
        get("#{@options[:username]}/videos.json").body
      end

      def likes
        get("#{@options[:username]}/likes.json").body
      end
    end
  end

  def self.client
    @client ||= Client.new
  end
end

vimeo_user = Vimeo.user(ENV['VIMEO_USERNAME'])

info = vimeo_user.info
videos = vimeo_user.videos.first(10)
likes = vimeo_user.likes.first(10)

puts <<OUTPUT
Name: #{info['display_name']}
Location: #{info['location']}

Videos:
#{videos.collect { |post| "- #{post['title']}" }.join("\n")}

Likes:
#{likes.collect { |post| "- #{post['title']}" }.join("\n")}
OUTPUT
