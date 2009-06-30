class ServiceWithParameterAliases < Relax::Service
  endpoint 'http://example.com/' do
    action :test do
      parameter :APIKey, :as => :api_key, :required => true

      parser :response do
        attribute :stat
      end
    end
  end
end

FakeWeb.register_uri(:get, 'http://example.com/?APIKey=secret', :string => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <response stat="ok">
  </response>
RESPONSE
