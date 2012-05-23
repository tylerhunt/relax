require 'spec_helper'

describe Relax::Client do
  let(:client) { Class.new { include Relax::Client } }

  subject { client }

  context '.parameter' do
    it 'defines an attribute reader' do
      expect {
        subject.parameter :api_key
      }.to change { subject.new.respond_to?(:api_key) }
    end

    it 'defines an attribute writer' do
      expect {
        subject.parameter :api_key
      }.to change { subject.new.respond_to?(:api_key=) }
    end

    it 'allows a default value to be specified' do
      subject.parameter :api_key, default: 'TEST'
      subject.new.config.api_key.should == 'TEST'
    end
  end

  context 'default parameters' do
    subject { client.new.config }

    its(:adapter) { should == Faraday.default_adapter }
    its(:base_uri) { should be_nil }
    its(:user_agent) { should == "Relax Ruby Gem Client #{Relax::VERSION}" }
  end

  context '#config' do
    subject { client.new }

    it 'returns a configuration object with defaults set' do
      subject.config.user_agent.should == Relax::Client::USER_AGENT
    end

    it 'memoizes the configuration' do
      subject.config.should == subject.config
    end
  end

  context '#configure' do
    subject { client.new }

    it 'yields an instance of the configuration' do
      expect {
        subject.configure do |config|
          config.base_uri = 'http://api.example.com/v2'
        end
      }.to change(subject.config, :base_uri).to('http://api.example.com/v2')
    end

    it 'returns the configuration' do
      subject.configure { }.should == subject.config
    end
  end
end
