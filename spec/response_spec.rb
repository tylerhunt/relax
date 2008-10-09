require File.dirname(__FILE__) + '/spec_helper'

require 'relax/response'

XML = <<EOF
<?xml version="1.0"?>
<RESTResponse>
  <Tokens>
    <TokenId>JPMQARDVJK</TokenId>
    <Status>Active</Status>
  </Tokens>
  <Tokens>
    <TokenId>RDVJKJPMQA</TokenId>
    <Status>Inactive</Status>
  </Tokens>
  <Status>Success</Status>
  <RequestId valid="true">44287</RequestId>
  <Error>
    <Code>1</Code>
    <Message>Failed</Message>
  </Error>
</RESTResponse>
EOF

class BaseResponse < Relax::Response
  parameter :status, :required => true
  parameter :request_id, :element => :requestid, :type => :integer
end

class TestResponse < BaseResponse
  class Token < Relax::Response
    parameter :token_id, :element => :tokenid
    parameter :status
  end

  class Error < Relax::Response
    parameter :code, :type => :integer
    parameter :message
  end

  parameter :valid_request, :element => :requestid, :attribute => :valid
  parameter :tokens, :collection => Token
  parameter :error, :type => Error
end

describe 'a response' do
  before(:each) do
    @response = Relax::Response.new(XML)
  end

  it 'should allow access to the root' do
    root = @response.root
    root.should be_an_instance_of(Hpricot::Elem)
    root.name.should eql('RESTResponse')
  end

  it 'should be checkable by the name of its root' do
    @response.is?(:RESTResponse).should be_true
  end

  it 'should allow access to an element by its name' do
    @response.element(:RequestId).should be_an_instance_of(Hpricot::Elem)
  end

  it 'should allow access to an element\'s elements by its name' do
    tokens = @response.elements(:Tokens)
    tokens.should be_an_instance_of(Hpricot::Elements)
    tokens.should_not be_empty
  end

  it 'should allow access to an element\'s value by its name' do
    token = Relax::Response.new(@response.elements(:Tokens).first)
    token.element(:TokenId).inner_text.should eql('JPMQARDVJK')
    token.element(:Status).inner_text.should eql('Active')
  end

  it 'should have a means of checking for the existence of a node' do
    @response.has?(:Status).should_not be_nil
    @response.has?(:Errors).should be_nil
  end

  it 'should be able to define children of Response without modifying parent' do
    Relax::Response.new(XML).respond_to?(:status).should be_false
    TestResponse.new(XML).respond_to?(:status).should be_true
  end

  it 'should automatically pull parameters from the XML' do
    response = TestResponse.new(XML)
    response.valid_request.should eql('true')
    response.tokens.length.should eql(2)
    response.tokens.first.status.should eql('Active')
    response.error.code.should eql(1)
    response.error.message.should eql('Failed')
  end

  it "should automatically pull its parent's parameters from the XML" do
    response = TestResponse.new(XML)
    response.status.should eql('Success')
    response.request_id.should eql(44287)
  end

  it 'should be relationally equivalent to its children' do
    (Relax::Response === TestResponse).should be_true
  end

  it 'should raise MissingParameter if required parameters are missing' do
    proc { TestResponse.new('') }.should raise_error(Relax::MissingParameter)
  end
end
