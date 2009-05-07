require 'rubygems'

gem 'relief', '~> 0.0.2'
require 'relief'

gem 'rest-client', '~> 0.9.2'
require 'restclient'

module Relax # :nodoc:
  autoload :Action, 'relax/action'
  autoload :Context, 'relax/context'
  autoload :Contextable, 'relax/contextable'
  autoload :Endpoint, 'relax/endpoint'
  autoload :Instance, 'relax/instance'
  autoload :Parameter, 'relax/parameter'
  autoload :Performer, 'relax/performer'
  autoload :Service, 'relax/service'
end
