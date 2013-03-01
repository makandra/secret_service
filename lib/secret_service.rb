require "secret_service/version"
require "secret_service/store"

module SecretService
  def self.secret(source_secret, options = {})
    if options[:plain]
      source_secret
    else
      @secrets[source_secret] ||= Store.instance.get(source_secret)
    end
  end
end
