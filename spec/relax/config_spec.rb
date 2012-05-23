require 'spec_helper'

describe Relax::Config do
  context '.build' do
    it 'defines an attribute reader' do
      config = described_class.build(api_key: {})
      config.should respond_to(:api_key)
    end

    it 'defines an attribute writer' do
      config = described_class.build(api_key: {})
      config.should respond_to(:api_key=)
    end

    it 'allows a default value to be specified' do
      config = described_class.build(api_key: { default: 'TEST' })
      config.api_key.should == 'TEST'
    end
  end
end
