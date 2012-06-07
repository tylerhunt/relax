require 'spec_helper'

describe Relax::Config do
  {
    USER_AGENT: "Relax Ruby Gem Client #{Relax::VERSION}",
    TIMEOUT: 60
  }.each do |constant, value|
    context "::#{constant}" do
      subject { described_class.const_get(constant) }

      it { should == value }
    end
  end

  context '.new' do
    subject { described_class.new }

    context 'defaults' do
      its(:adapter) { should == Faraday.default_adapter }
      its(:base_uri) { should be_nil }
      its(:timeout) { should == 60 }
      its(:user_agent) { should == "Relax Ruby Gem Client #{Relax::VERSION}" }
    end
  end
end
