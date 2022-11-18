require './lib/relax/version'

Gem::Specification.new do |spec|
  spec.name = 'relax'
  spec.version = Relax::VERSION
  spec.authors = ['Tyler Hunt']
  spec.summary = 'A flexible library for creating web service consumers.'
  spec.homepage = 'http://github.com/tylerhunt/relax'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'appraisal', '~> 2.4'

  spec.files = `git ls-files`.split($\)
  spec.executables = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
