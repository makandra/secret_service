require 'secret_service/database_store'

require 'securerandom'
require 'singleton'
require 'gibberish'

module SecretService
  class Store

    def get(source_secret, options = {})
      decrypt(database_secret(source_secret, options), source_secret)
    end

    def set(source_secret, final_secret)
      database_store.update(database_key(source_secret), encrypt(final_secret, source_secret))
    end

    def generate_secret
      SecureRandom.hex(32)
    end


    private

    def database_store
      @database_store ||= DatabaseStore.get
    end

    def database_secret(source_secret, options = {})
      secret = database_store.find(database_key(source_secret)) do
        return nil if options[:only_existing]
        encrypt(generate_secret, source_secret)
      end
    end

    def database_key(source_secret)
      Gibberish::SHA256(source_secret)
    end

    def encrypt(plain_text, key)
      aes(key).encrypt(plain_text) if plain_text
    end

    def decrypt(cipher_text, key)
      aes(key).decrypt(cipher_text) if cipher_text
    end

    def aes(key)
      Gibberish::AES.new(key)
    end
  end
end
