$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'

gem 'rspec', '~> 1.2.2'
require 'spec'

gem 'fakeweb', '~> 1.2.2'
require 'fakeweb'

require File.join(File.dirname(__FILE__), '..', 'lib', 'relax')
require File.join(File.dirname(__FILE__), 'services', 'flickr')
require File.join(File.dirname(__FILE__), 'services', 'service_with_custom_parser')
require File.join(File.dirname(__FILE__), 'services', 'service_with_parameter_aliases')
