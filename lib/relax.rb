$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'relax/query'
require 'relax/request'
require 'relax/response'
require 'relax/service'
require 'relax/symbolic_hash'

module Relax
  class MissingParameter < ArgumentError ; end
end
