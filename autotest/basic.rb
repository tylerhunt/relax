class Autotest::Basic < Autotest
  
  def initialize
    super
    
    # Ignore non-source directories
    add_exception %r%\A\./(?:autotest|rdoc|\.git)%
    
    # Ignore misc files
    add_exception %r%\A\./(.*LICENSE|Rakefile|README.*|CHANGELOG.*)\Z%i
    
    clear_mappings
    
    # Any saved test file should run
    self.add_mapping(%r%\Aspec/.*_spec\.rb\Z%) do |filename, matches|
      filename
    end
    
    # Any lib/ file that matches a test file, run the test.
    self.add_mapping(%r%\Alib/(.*)\.rb\Z%) do |filename, matches|
      filename_path = matches[1]
      files_matching %r%\Aspec/#{Regexp.escape(filename_path)}_spec\.rb\Z%
    end
    
    # If the test_helper is modified, re-run all tests.
    self.add_mapping(%r%\Aspec/.*_helper\.rb\Z%) do
      files_matching %r%\Aspec/.*_spec\.rb\Z%
    end
    
  end
  
end