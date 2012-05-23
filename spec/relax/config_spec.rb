require 'spec_helper'

describe Relax::Config do
  context '#configure' do
    it 'yields an instance of the configuration' do
      expect {
        subject.configure do |config|
          config.base_uri = 'http://api.example.com/v2'
        end
      }.to change(subject, :base_uri).to('http://api.example.com/v2')
    end

    it 'returns the configuration' do
      subject.configure { }.should == subject
    end
  end
end
