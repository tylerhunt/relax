require 'spec_helper'

describe Relax::Resource do
  let(:client) do
    Class.new do
      include Relax::Client

      def initialize
        config.base_uri = 'http://api.example.com/v2'
      end
    end.new
  end

  let(:resource_class) { Class.new { include Relax::Resource } }

  subject { resource_class.new(client) }

  context '.new' do
    it 'accepts an options hash' do
      resource_class.new(client, key: :value)
    end
  end

  context '#connection' do
    let(:connection) { subject.send(:connection) }

    it 'returns an instance of Faraday::Connection' do
      connection.should be_a(Faraday::Connection)
    end

    it 'uses the configured base URI as the URL' do
      connection.url_prefix.should == URI.parse(client.config.base_uri)
    end

    it 'uses the configured timeout' do
      connection.options[:timeout].should == client.config.timeout
    end

    it 'accepts an options hash to be passed to Faraday::Connection' do
      headers = { user_agent: "#{described_class} Test" }
      connection = subject.send(:connection, headers: headers)
      connection.headers['User-Agent'].should == headers[:user_agent]
    end

    it 'yields a builder to allow the middleware to be customized' do
      subject.send(:connection) do |builder|
        builder.use(Faraday::Response::Logger)
      end.builder.handlers.should include(Faraday::Response::Logger)
    end
  end

  context 'connection delegation' do
    let(:connection) { stub(:connection) }

    before { subject.stub(:connection).and_return(connection) }

    Faraday::Connection::METHODS.each do |method|
      it "delegates ##{method} to #connection" do
        connection.should_receive(method)
        subject.send(method)
      end
    end
  end
end
