describe 'a successfully parsed response', :shared => true do
  it 'should allow access to the root' do
    root = @response.root
    root.should_not be_nil
    root.name.should eql('RESTResponse')
  end

  it 'should be checkable by the name of its root' do
    @response.is?(:RESTResponse).should be_true
  end

  it 'should allow access to an element by its name' do
    @response.element(:RequestId).should_not be_nil
  end

  it 'should allow access to an element\'s elements by its name' do
    tokens = @response.elements(:Tokens)
    tokens.should respond_to(:each)
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

  it 'should set known parameters' do
    @response.status.should eql('Success')
    @response.request_id.should eql(44287)
    @response.valid_request.should eql("true")
  end

  it 'should automatically pull parameters from the XML' do
    @response.tokens.length.should eql(2)
    @response.tokens.first.status.should eql('Active')
    @response.error.code.should eql(1)
    @response.error.message.should eql('Failed')
  end

  it 'should raise MissingParameter if required parameters are missing' do
    proc { @response.class.new('') }.should raise_error(Relax::MissingParameter)
  end
end
