require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = "relax"
    gem.summary = %Q{A flexible library for creating web service consumers.}
    gem.email = "tyler@tylerhunt.com"
    gem.homepage = "http://github.com/tylerhunt/relax"
    gem.authors = ["Tyler Hunt"]
    gem.rubyforge_project = 'relax'

    gem.add_dependency('rest-client', '~> 0.9.2')
    gem.add_dependency('relief', '~> 0.0.4')

    gem.add_development_dependency('jeweler', '~> 0.11.0')
    gem.add_development_dependency('rspec', '~> 1.2.2')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

task :default => :spec

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "relief #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
