RSpec.describe Relax::Delegator do
  let(:client) { Class.new { include Relax::Client } }

  subject(:delegator) do
    Class.new do
      extend Relax::Delegator[:client]

      class << self
        attr :client, true
      end
    end
  end

  before { delegator.client = client.new }

  context '.[]' do
    it 'accepts a client method name and returns a module' do
      expect(described_class[:client]).to be_a Module
    end
  end

  context 'delegation' do
    Relax::Client.instance_methods.each do |method|
      it "delegates .#{method} to the client" do
        expect(delegator.client).to receive(method)

        delegator.send method
      end
    end
  end
end
