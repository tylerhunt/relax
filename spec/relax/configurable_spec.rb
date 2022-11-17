RSpec.describe Relax::Configurable do
  subject(:configurable) { Class.new { include Relax::Configurable }.new }

  context '#config' do
    it 'returns an instance of Relax::Config' do
      expect(configurable.config).to be_a Relax::Config
    end

    it 'memoizes the configuration' do
      expect(configurable.config).to eq configurable.config
    end
  end

  context '#configure' do
    it 'yields an instance of the configuration' do
      expect { |block| configurable.configure &block }
        .to yield_with_args(configurable.config)
    end

    it 'returns self' do
      expect(configurable.configure {}).to eq configurable
    end
  end
end
