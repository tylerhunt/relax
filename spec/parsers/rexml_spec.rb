require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../parser_helper'


class RexmlTestResponse < Relax::Response
  class Token < Relax::Response
    parser :rexml
    parameter :token_id,  :element => 'TokenId'
    parameter :status,    :element => 'Status'
  end
  
  class Error < Relax::Response
    parser :rexml
    parameter :code,      :element => 'Code',         :type => :integer
    parameter :message,   :element => 'Message'
  end
  
  parser :rexml
  parameter :status,        :element => 'Status',     :required => true
  parameter :request_id,    :element => 'RequestId',  :type => :integer
  parameter :valid_request, :element => 'RequestId',  :attribute => :valid
  parameter :namespace,     :element => 'Namespace',  :namespace => 'ns1'
  parameter :tokens,        :element => 'Tokens',     :collection => Token
  parameter :error,         :element => 'Error',      :type => Error
end


describe 'a REXML parser' do
  
  before(:each) do
    @response = RexmlTestResponse.new(XML)
  end
  
  it_should_behave_like 'a successfully parsed response'
  
  it 'should parse namespaced parameters' do
    @response.namespace.should eql('Passed')
  end
  
end