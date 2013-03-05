DatabaseCleaner.strategy = :truncation

(defined?(Spec) ? Spec::Runner : RSpec).configure do |config|
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end
