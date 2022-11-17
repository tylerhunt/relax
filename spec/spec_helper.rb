require 'relax'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require(file)
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
