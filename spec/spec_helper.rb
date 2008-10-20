require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/../lib/relax'

unless defined?(XML)
XML = <<EOF
<?xml version="1.0"?>
<RESTResponse xmlns:ns1="http://namespace.url">
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
  <ns1:Namespace>Passed</ns1:Namespace>
  <Error>
    <Code>1</Code>
    <Message>Failed</Message>
  </Error>
</RESTResponse>
EOF
end