require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Relax::Endpoint do
  it "provides access to the URL" do
    service = Class.new(Relax::Service)
    endpoint = service.endpoint("http://api.example.com/") { }
    endpoint.url.should == "http://api.example.com/"
  end

  it "allows contextual defaults to be set" do
    service = Class.new(Relax::Service)
    endpoint = service.endpoint("http://api.example.com/") { }
    endpoint.should respond_to(:defaults)
  end

  describe "actions" do
    it "should check for required values for service defaults" do
      service = Class.new(Relax::Service) do
        defaults { parameter :api_key, :required => true }
        endpoint("http://api.example.com/") { action(:fetch) { } }
      end

      proc {
        service.new.fetch
      }.should raise_error(ArgumentError, /missing.*api_key/i)
    end

    it "should check for required values for endpoint defaults" do
      service = Class.new(Relax::Service) do
        endpoint("http://api.example.com/") do
          defaults { parameter :operation, :required => true }
          action(:fetch) { }
        end
      end

      proc {
        service.new.fetch
      }.should raise_error(ArgumentError, /missing.*operation/i)
    end

    it "should check for required values for action parameters" do
      service = Class.new(Relax::Service) do
        endpoint("http://api.example.com/") do
          action(:fetch) { parameter :id, :required => true }
        end
      end

      proc {
        service.new.fetch
      }.should raise_error(ArgumentError, /missing.*id/i)
    end

    it "should create required parameters from tokens in the endpoint URL" do
      service = Class.new(Relax::Service) do
        endpoint("http://api.example.com/:version/") do
          action(:fetch) { parameter :id }
        end
      end

      proc {
        service.new.fetch
      }.should raise_error(ArgumentError, /missing.*version/i)
    end

    it "should replace parameter tokens in the endpoint URL" do
      service = Class.new(Relax::Service) do
        endpoint("http://api.example.com/:version/") do
          action(:fetch) do
            parameter :id
            parser(:xml) { attribute :status }
          end
        end
      end

      FakeWeb.register_uri(:get, 'http://api.example.com/v1/', :string => <<-RESPONSE)
        <?xml version="1.0" encoding="utf-8" ?>
        <response status="ok" />
      RESPONSE

      service.new(:version => 'v1').fetch.should == { :status => 'ok' }
    end
  end

  describe ".action" do
    it "is callable from within an Endpoint" do
      service = Class.new(Relax::Service)
      endpoint = service.endpoint("http://api.example.com/") { }
      endpoint.should respond_to(:action)
    end

    it "defines an instance method by the same name on the Service" do
      service = Class.new(Relax::Service)
      service.new.should_not respond_to(:fetch)

      service.endpoint("http://api.example.com/") { action :fetch }
      service.new.should respond_to(:fetch)
    end
  end
end
