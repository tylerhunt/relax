require './lib/relax/version'

Gem::Specification.new do |gem|
  gem.name = 'relax'
  gem.version = Relax::VERSION
  gem.summary = 'A flexible library for creating web service consumers.'
  gem.homepage = 'http://github.com/tylerhunt/relax'
  gem.author = 'Tyler Hunt'

  gem.add_dependency 'faraday', '~> 0.8.0'
  gem.add_development_dependency 'rspec', '~> 2.6'

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
