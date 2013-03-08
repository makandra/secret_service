require "secret_service/version"
require "secret_service/store"

module SecretService

  class << self

    def secret(source_secret)
      @secrets ||= {}
      @secrets[source_secret] ||= Store.new.get(source_secret)
    end

    private

    def store
      @store ||= Store.new
    end

    def reset
      @secrets = nil
      @store = nil
    end

  end

  if defined?(Rails::Railtie)
    class RakeTaskLoader < Rails::Railtie
      rake_tasks do
        require 'secret_service/rake_tasks'
      end
    end
  end

end
