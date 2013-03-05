require 'secret_service/database_store'

require 'securerandom'
require 'singleton'
require 'gibberish'

module SecretService
  class Store
    include Singleton

    def get(source_secret)
      decrypt(database_secret(source_secret), source_secret)
    end

    def set(source_secret, final_secret)
      database_store.update(database_key(source_secret), encrypt(final_secret, source_secret))
    end

    private

    def database_store
      @database_store ||= DatabaseStore.get
    end

    def database_secret(source_secret)
      secret = database_store.find(database_key(source_secret)) do
        encrypt(generate_secret, source_secret)
      end
    end

    def database_key(source_secret)
      Gibberish::SHA256(source_secret)
    end

    def encrypt(plain_text, key)
      aes(key).encrypt(plain_text)
    end

    def decrypt(cipher_text, key)
      aes(key).decrypt(cipher_text)
    end

    def generate_secret
      SecureRandom.hex(32)
    end

    def aes(key)
      Gibberish::AES.new(key)
    end
  end
end
