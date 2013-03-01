require 'secret_service/database_store'

require 'securerandom'
require 'singleton'

module SecretService
  class Store
    include Singleton

    def get(source_secret)
      hash("#{source_secret}--#{database_secret(source_secret)}")
    end

    private

    def database_store
      @database_store ||= DatabaseStore.get
    end

    def database_secret(source_secret)
      secret = database_store.find(hash(source_secret)) do
        generate_secret
      end
    end

    def hash(value)
      Gibberish::SAH256(value)
    end

    def generate_secret
      SecureRandom.hex(32)
    end
  end
end
