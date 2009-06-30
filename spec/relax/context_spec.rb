require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Relax::Context do
  it "utilizes a custom parser for Class parsers" do
    service = CustomParserService.new
    service.test.should == 'parsed'
  end

  it "allows parameters with aliases" do
    service = ParameterAliasService.new
    service.test(:api_key => 'secret')[:stat].should == 'ok'
  end

  it "allows blank parameters values" do
    service = BlankValuesService.new({}, :include_blank_values => true)
    service.test[:stat].should == 'ok'
  end
end
