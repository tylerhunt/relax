# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{relax}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tyler Hunt"]
  s.date = %q{2009-05-07}
  s.email = %q{tyler@tylerhunt.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README"
  ]
  s.files = [
    "LICENSE",
    "Rakefile",
    "VERSION.yml",
    "lib/relax.rb",
    "lib/relax/action.rb",
    "lib/relax/context.rb",
    "lib/relax/contextable.rb",
    "lib/relax/endpoint.rb",
    "lib/relax/instance.rb",
    "lib/relax/parameter.rb",
    "lib/relax/performer.rb",
    "lib/relax/service.rb",
    "spec/relax/endpoint_spec.rb",
    "spec/relax/integration_spec.rb",
    "spec/relax/service_spec.rb",
    "spec/services/flickr.rb",
    "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tylerhunt/relax}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{relax}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A flexible library for creating web service consumers.}
  s.test_files = [
    "spec/relax/endpoint_spec.rb",
    "spec/relax/integration_spec.rb",
    "spec/relax/service_spec.rb",
    "spec/services/flickr.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, ["~> 0.9.2"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.2.3"])
      s.add_runtime_dependency(%q<relief>, ["~> 0.0.3"])
      s.add_development_dependency(%q<jeweler>, ["~> 0.11.0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.2.2"])
    else
      s.add_dependency(%q<rest-client>, ["~> 0.9.2"])
      s.add_dependency(%q<nokogiri>, ["~> 1.2.3"])
      s.add_dependency(%q<relief>, ["~> 0.0.3"])
      s.add_dependency(%q<jeweler>, ["~> 0.11.0"])
      s.add_dependency(%q<rspec>, ["~> 1.2.2"])
    end
  else
    s.add_dependency(%q<rest-client>, ["~> 0.9.2"])
    s.add_dependency(%q<nokogiri>, ["~> 1.2.3"])
    s.add_dependency(%q<relief>, ["~> 0.0.3"])
    s.add_dependency(%q<jeweler>, ["~> 0.11.0"])
    s.add_dependency(%q<rspec>, ["~> 1.2.2"])
  end
end
