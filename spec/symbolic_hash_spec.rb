require File.dirname(__FILE__) + '/spec_helper'

require 'relax/symbolic_hash'

describe 'a symbolic hash' do
  before(:each) do
    @url = 'http://example.com/'
    @query = Relax::SymbolicHash.new
  end

  it 'should be accessible via string or symbol keys' do
    @query[:amount] = 10
    @query[:amount].should == 10
    @query['amount'].should == 10
  end

  it 'should convert keys to symbols' do
    @query['symbol'] = 'aleph'
    @query[:symbol].should == 'aleph'
  end

  it 'should convert keys to symbols' do
    @query['symbol'] = 'aleph'
    @query[:symbol].should == 'aleph'
  end

  it 'should test for keys by symbol' do
    @query[:symbol] = 'aleph'
    @query.key?('symbol').should be_true
  end

  it 'should delete values with a symbolic key' do
    @query[:symbol] = 'aleph'
    @query.delete('symbol')
    @query.key?(:symbol).should be_false
  end

  it 'should be mergeable' do
    @query[:one] = 2
    merged_query = @query.merge({ :one => 1, :two => 2 })
    merged_query[:one].should == 1
    merged_query[:two].should == 2
  end

  it 'should be able to duplicate itself' do
    @query[:one] = 'uno'
    @query[:two] = 'dos'
    new_query = @query.dup
    new_query[:one].should == 'uno'
    new_query[:two].should == 'dos'

    @query[:three] == 'tres'
    new_query.key?(:three).should be_false
  end

  it 'should be able to get multiple values by symbol' do
    @query[:one] = 1
    @query[:two] = 2
    @query.values_at(:one, :two).should == [1, 2]
  end

  it 'should be instantiable with a hash' do
    query = Relax::SymbolicHash.new({ :one => 1, :two => 2 })
    query[:one].should == 1
    query[:two].should == 2
  end
end
