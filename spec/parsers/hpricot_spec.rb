require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../parser_helper'

class HpricotTestResponse < Relax::Response
  class Token < Relax::Response
    parser :hpricot
    parameter :token_id, :element => :tokenid
    parameter :status
  end

  class Error < Relax::Response
    parser :hpricot
    parameter :code, :type => :integer
    parameter :message
  end

  parser :hpricot
  parameter :status, :required => true
  parameter :request_id, :element => :requestid, :type => :integer
  parameter :valid_request, :element => :requestid, :attribute => :valid
  parameter :tokens, :collection => Token
  parameter :error, :type => Error
end

describe 'an Hpricot parser' do
  before(:each) do
    @response = HpricotTestResponse.new(XML)
  end

  it_should_behave_like 'a successfully parsed response'
end
