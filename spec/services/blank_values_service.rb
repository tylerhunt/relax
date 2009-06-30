class BlankValuesService < Relax::Service
  endpoint 'http://example.com/' do
    action :test do
      parameter :one
      parameter :two
      parameter :three

      parser :response do
        attribute :stat
      end
    end
  end
end

FakeWeb.register_uri(:get, 'http://example.com/?one=&two=&three=', :string => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <response stat="ok">
  </response>
RESPONSE
