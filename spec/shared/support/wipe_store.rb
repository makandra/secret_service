module SecretServiceSpec
  def self.wipe_store
    SecretService.send(:reset)
    SecretService::DatabaseStore.get.drop_database
  end
end

(defined?(Spec) ? Spec::Runner : RSpec).configure do |config|
  config.before(:each) { SecretServiceSpec.wipe_store }
end
