require File.dirname(__FILE__) + '/spec_helper'

require 'relax/request'

class Amount < Relax::Request
  parameter :amount
  parameter :currency
end

class TestRequest < Relax::Request
  parameter :action
  parameter :token_id
  parameter :user_id
  parameter :amount, :type => Amount
end

class ChildRequest < TestRequest
  parameter :child_id
end

describe 'an option initialized request', :shared => true do
  it 'should have its values set by the options hash' do
    request = TestRequest.new(:action => 'FetchAll', :token_id => 123)
    request.action.should eql('FetchAll')
    request.token_id.should eql(123)
    request.user_id.should be_nil
  end
end

describe 'a request that converts to a query', :shared => true do
  before(:each) do
    @query = TestRequest.new(:action => 'Search', :token_id => 123).to_query
  end

  it 'should include its parameters in the query' do
    @query[:action].should eql('Search')
    @query[:token_id].should eql('123')
    @query[:user_id].should be_nil
    @query[:amount].should be_nil
  end

  it 'should only include parameters in the query if they are set' do
    @query.key?(:action).should be_true
    @query.key?(:token_id).should be_true
    @query.key?(:user_id).should be_false
    @query.key?(:amount).should be_false
  end
end

describe 'a normal request' do
  it_should_behave_like 'a request that converts to a query'
  it_should_behave_like 'an option initialized request'
end

describe 'a template request' do
  it_should_behave_like 'a request that converts to a query'
  it_should_behave_like 'an option initialized request'

  before(:each) do
    # this syntax may need to go away unless we can find a way to make it work 
    TestRequest[:api_key] = '123456'
    TestRequest[:secret] = 'shhh!'
  end

  it 'should always have the template values in its query' do
    request = TestRequest.new
    request.api_key.should eql('123456')
    request.secret.should eql('shhh!')
  end

  it 'should allow its template variables to be overridden' do
    request = TestRequest.new(:secret => 'abracadabra')
    request.api_key.should eql('123456')
    request.secret.should eql('abracadabra')
  end

  it 'should pass its template on to its children' do
    request = ChildRequest.new
    request.api_key.should eql('123456')
    request.secret.should eql('shhh!')
  end

  it 'should allow template parameters on its children that are additive' do
    ChildRequest[:query] = '1a2b3c'
    child = ChildRequest.new
    child.api_key.should eql('123456')
    child.secret.should eql('shhh!')
    child.query.should eql('1a2b3c')

    parent = TestRequest.new
    parent.api_key.should eql('123456')
    parent.secret.should eql('shhh!')
    parent.respond_to?(:query).should be_false
  end
end

describe 'a request with a custom type' do
  before(:each) do
    request = TestRequest.new(:action => 'Pay', :token_id => 123)
    request.amount = Amount.new(:amount => 3.50, :currency => 'USD')
    @query = request.to_query
  end

  it 'should add the type parameters to the query' do
    @query.key?(:"amount.amount").should be_true
    @query.key?(:"amount.currency").should be_true
  end
end
