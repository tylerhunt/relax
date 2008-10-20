Gem::Specification.new do |s|
  s.name = %q{relax}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tyler Hunt"]
  s.date = %q{2008-10-20}
  s.email = %q{tyler@tylerhunt.com}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["lib/relax", "lib/relax/parsers", "lib/relax/parsers/base.rb", "lib/relax/parsers/factory.rb", "lib/relax/parsers/hpricot.rb", "lib/relax/parsers/rexml.rb", "lib/relax/parsers.rb", "lib/relax/query.rb", "lib/relax/request.rb", "lib/relax/response.rb", "lib/relax/service.rb", "lib/relax/symbolic_hash.rb", "lib/relax.rb", "spec/parsers/factory_spec.rb", "spec/parsers/hpricot_spec.rb", "spec/parsers/rexml_spec.rb", "spec/query_spec.rb", "spec/request_spec.rb", "spec/response_spec.rb", "spec/symbolic_hash_spec.rb", "README", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://tylerhunt.com/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{relax}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A simple library for creating REST consumers.}
  s.test_files = ["spec/parsers/factory_spec.rb", "spec/parsers/hpricot_spec.rb", "spec/parsers/rexml_spec.rb", "spec/query_spec.rb", "spec/request_spec.rb", "spec/response_spec.rb", "spec/symbolic_hash_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6"])
  end
end
