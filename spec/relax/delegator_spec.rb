require 'spec_helper'

describe Relax::Delegator do
  let(:client) { Class.new { include Relax::Client } }

  subject { Class.new { include Relax::Delegator } }

  context '.delegate_to' do
    it 'sets the client for the delegator' do
      subject.delegate_to(client)
      subject.send(:client).should be_a(client)
    end
  end

  context 'delegation' do
    before { subject.delegate_to(client) }

    [:config, :configure].each do |method|
      it "delegates .#{method} to .delegator" do
        subject.send(:client).should_receive(method)
        subject.send(method)
      end
    end
  end
end
