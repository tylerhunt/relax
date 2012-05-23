require 'spec_helper'

describe Relax::Delegator do
  let(:client) { Class.new { include Relax::Client } }

  subject do
    Class.new do
      extend Relax::Delegator[:client]

      class << self
        attr :client, true
      end
    end
  end

  before { subject.client = client.new }

  context '.[]' do
    it 'accepts a client method name and returns a module' do
      described_class[:client].should be_a(Module)
    end
  end

  context 'delegation' do
    Relax::Client.instance_methods.each do |method|
      it "delegates .#{method} to .delegator" do
        subject.client.should_receive(method)
        subject.send(method)
      end
    end
  end
end
