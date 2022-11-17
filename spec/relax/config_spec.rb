RSpec.describe Relax::Config do
  {
    USER_AGENT: "Relax Ruby Gem Client #{Relax::VERSION}",
    TIMEOUT: 60
  }.each do |constant, value|
    context "::#{constant}" do
      subject { described_class.const_get(constant) }

      it { is_expected.to eq value }
    end
  end

  subject(:config) { described_class.new }

  context '#adapter' do
    it 'defaults to Faraday’s default adapter' do
      expect(config.adapter).to eq Faraday.default_adapter
    end
  end

  context '#base_uri' do
    it 'defaults to nil' do
      expect(config.base_uri).to be_nil
    end
  end

  context '#adapter' do
    it 'has a default value' do
      expect(config.timeout).to eq 60
    end
  end

  context '#adapter' do
    it 'has a default value' do
      expect(config.user_agent).to eq "Relax Ruby Gem Client #{Relax::VERSION}"
    end
  end
end
