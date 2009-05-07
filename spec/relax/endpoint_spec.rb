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
    it "actions should check for required values for service defaults" do
      service = Class.new(Relax::Service) do
        defaults { parameter :api_key, :required => true }
        endpoint("http://api.example.com/") { action(:fetch) { } }
      end

      proc {
        service.new.fetch
      }.should raise_error(ArgumentError, /missing.*api_key/i)
    end

    it "actions should check for required values for endpoint defaults" do
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

    it "actions should check for required values for action parameters" do
      service = Class.new(Relax::Service) do
        endpoint("http://api.example.com/") do
          action(:fetch) { parameter :id, :required => true }
        end
      end

      proc {
        service.new.fetch
      }.should raise_error(ArgumentError, /missing.*id/i)
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
