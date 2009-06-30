require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Relax::Context do
  it "utilizes a custom parser for Class parsers" do
    service = ServiceWithCustomParser.new
    service.test.should == 'parsed'
  end

  it "allows parameters with aliases" do
    service = ServiceWithParameterAliases.new
    service.test(:api_key => 'secret')[:stat].should == 'ok'
  end
end
