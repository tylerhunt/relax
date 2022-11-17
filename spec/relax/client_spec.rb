RSpec.describe Relax::Client do
  subject(:client) { Class.new { include Relax::Client }.new }

  context '#config' do
    it 'returns an instance of Relax::Config' do
      expect(client.config).to be_a Relax::Config
    end

    it 'memoizes the configuration' do
      expect(client.config).to eq client.config
    end
  end

  context '#configure' do
    it 'yields an instance of the configuration' do
      expect { |block| client.configure &block }
        .to yield_with_args(client.config)
    end

    it 'returns self' do
      expect(client.configure {}).to eq client
    end
  end
end
