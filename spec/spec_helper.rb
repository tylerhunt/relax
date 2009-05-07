$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'

gem 'rspec', '~> 1.2.2'
require 'spec'

gem 'fakeweb', '~> 1.2.2'
require 'fakeweb'

require File.join(File.dirname(__FILE__), '..', 'lib', 'relax')
require File.join(File.dirname(__FILE__), 'services', 'flickr')
