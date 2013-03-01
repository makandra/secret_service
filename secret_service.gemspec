# -*- encoding: utf-8 -*-
require File.expand_path('../lib/secret_service/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tobias Kraze"]
  gem.email         = ["tobias@kraze.eu"]
  gem.description   = %q{Secret service provides encryption of your application secrets with a server side master password}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "secret_service"
  gem.require_paths = ["lib"]
  gem.version       = SecretService::VERSION

  gem.add_dependency('gibberish')
end
