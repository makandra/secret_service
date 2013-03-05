$: << File.join(File.dirname(__FILE__), "/../../lib" )

# Set the default environment to sqlite3's in_memory database
ENV['RAILS_ENV'] ||= 'test'
ENV['RAILS_ROOT'] = 'app_root'

# Load the Rails environment and testing framework
require "#{File.dirname(__FILE__)}/../app_root/config/environment"
require 'rspec/rails'


# Requires supporting files with custom matchers and macros, etc in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.use_instantiated_fixtures  = false
end
