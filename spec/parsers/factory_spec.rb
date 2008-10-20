require File.dirname(__FILE__) + '/../spec_helper'

require 'relax'
require 'relax/parsers/factory'

class TestParser ; end

describe 'a parser factory' do
  
  before(:each) do
    @factory = Relax::Parsers::Factory
    Relax::Parsers::Factory.register(:test, TestParser)
  end
  
  it 'should raise UnrecognizedParser for un-registered names' do
    lambda {
      @factory.get(:bad_name)
    }.should raise_error(Relax::UnrecognizedParser)
  end
  
  it 'should return a registered parser class' do
    @factory.get(:test).should ==TestParser
  end
  
  it 'should register the first registered parser as the default' do
    @factory.get(:default).should ==Relax::Parsers::Hpricot
  end
  
end