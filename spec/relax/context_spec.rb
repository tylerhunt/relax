require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Relax::Context do
  
  it "utilizes a custom parser for Class parsers" do
    service = ServiceWithCustomParser.new
    service.test.should == 'parsed'
  end
  
end
