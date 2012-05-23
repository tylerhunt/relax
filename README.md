# Relax

A library of simple modules for building web service wrappers.


## Usage

Relax a toolkit of sorts, which makes it easier to write Faraday-based API
Gems while still leaning heavily on the strengths of the Ruby language.

### Overview

Relax is made up of three primary modules:

  * `Relax::Client` — forms the basis of a web service wrapper by storing the
    configuration and serving as a factory for resources

  * `Relax::Resource` — used to handle the actual web service connections and
    help organize related endpoints

  * `Relax::Delegator` — delegates class methods to an instance of the client
    allowing for simple client usage

### Example

``` ruby
require 'relax'
require 'faraday_middleware' # for JSON response parsing

module Vimeo
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

      def videos
        get("#{@options[:username]}/videos.json").body
      end
    end
  end

  include Relax::Delegator

  delegate_to Client
end

Vimeo.user(ENV['VIMEO_USERNAME']).videos
```

See the [`examples` directory][examples] for more.

[examples]: http://github.com/tylerhunt/relax/examples


## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature.'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.
