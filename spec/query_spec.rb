require File.dirname(__FILE__) + '/spec_helper'

require 'relax/query'

describe 'a query' do
  before(:each) do
    @uri = URI::parse('http://example.com/?action=search&query=keyword')
    @query = Relax::Query.new
  end

  it 'should convert to a query string' do
    @query[:action] = 'Search'
    @query[:query] = 'strings'
    @query.to_s.should eql('action=Search&query=strings')
  end

  it 'should convert its values to strings' do
    date = Date.today
    @query[:date] = date
    @query.to_s.should eql("date=#{date.to_s}")
  end

  it 'should escape its values using "+" instead of "%20"' do
    Relax::Query.send(:escape_value, 'two words').should == 'two+words'
  end
  
  it 'should sort its parameters' do
    @query[:charlie] = 3
    @query[:alpha] = 1
    @query[:bravo] = 2
    @query.to_s.should eql('alpha=1&bravo=2&charlie=3')
  end

  it 'should encode its parameter values' do
    @query[:spaces] = 'two words'
    @query[:url] = 'http://example.com/'
    @query.to_s.should eql('spaces=two+words&url=http%3A%2F%2Fexample.com%2F')
  end

  it 'should be able to parse query strings' do
    parsed_query = Relax::Query.parse(@uri)
    parsed_query[:action].should eql('search')
    parsed_query[:query].should eql('keyword')
  end
  
  it 'should parse key value pairs into only two parts' do
    parsed_query = Relax::Query.parse(URI.parse("http://example.com/?action=test=&foo=bar"))
    parsed_query[:action].should eql('test=')
  end
  
  it 'should unescape query string key-value pair keys' do
    parsed_query = Relax::Query.parse(URI.parse("http://example.com/?action%20helper=test"))
    parsed_query[:"action helper"].should eql('test')
  end
  
  it 'should unescape query string key-value pair values' do
    parsed_query = Relax::Query.parse(URI.parse("http://example.com/?action=test%20action"))
    parsed_query[:action].should eql('test action')
  end
end
