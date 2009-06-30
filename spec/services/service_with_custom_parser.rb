class TestCustomParser
  def initialize(options = {}, &block)
  end

  def parse(input)
    'parsed'
  end
end

class ServiceWithCustomParser < Relax::Service
  endpoint "http://test.local/rest" do
    action :test do
      parser TestCustomParser do
        element :status, :attribute => :stat
      end
    end
  end
end

FakeWeb.register_uri(:get, 'http://test.local/rest', :string => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <test stat="ok">
  </test>
RESPONSE
