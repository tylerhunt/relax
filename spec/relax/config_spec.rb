require 'spec_helper'

describe Relax::Config do
  let(:configurator) { Class.new { include Relax::Config } }

  subject { configurator }

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
      subject.new.api_key.should == 'TEST'
    end
  end

  context 'default parameters' do
    subject { configurator.new }

    its(:adapter) { should == Faraday.default_adapter }
    its(:base_uri) { should be_nil }
    its(:user_agent) { should == "Relax Ruby Gem Client #{Relax::VERSION}" }
  end
end
