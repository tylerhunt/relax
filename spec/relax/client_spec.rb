require 'spec_helper'

describe Relax::Client do
  let(:configurator) { Class.new { include Relax::Config } }

  subject { Class.new { include Relax::Client } }

  context '.configure_with' do
    it 'sets the configurator for the client' do
      subject.configure_with(configurator)
      subject.configurator.should == configurator
    end
  end

  context '#config' do
    let(:client) { subject.new }

    before { subject.configure_with(configurator) }

    it 'returns an instance of the configurator' do
      client.config.should be_a(configurator)
    end

    it 'memoizes the configuration' do
      client.config.should == client.config
    end
  end

  context '#configure' do
    let(:client) { subject.new }

    before { subject.configure_with(configurator) }

    it 'yields an instance of the configurator' do
      expect {
        client.configure do |config|
          config.base_uri = 'http://api.example.com/v2'
        end
      }.to change(client.config, :base_uri).to('http://api.example.com/v2')
    end

    it 'returns the configurator' do
      client.configure { }.should == client.config
    end
  end
end
