require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/../lib/relax'

unless defined?(XML)
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
end