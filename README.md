# SecretService

SecretService allows you to store secrets (for example the session secret or other shared secrets) more securely.

It does this by distributing the actual secret between your code and your database. That is, the final secret can only be calculated if you know both the secret given in your code and a secret stored in your database.

Secrets can either be generated randomly on first use, or set using the Raketask.

The Gem does its job by using the secret given in your code to encrypt/decrypt the secret in the database.

As a useful sideeffect this means your different environments (staging / production) will automatically use different secrets.



## Caveat

This currently requires ActiveRecord.

## Installation

Add this line to your application's Gemfile:

    gem 'secret_service'

And then execute:

    $ bundle

## Usage

To get a random secret, simply use

    SecretService.secret("dfa24decafdb058448ac1eadb94e2066381cb92ee301e5a43d556555b61c7ea599e06be870e1d90c655c1b56cea172622d2b04a5e986faed42cbae684c5523c9")

The database entries (and indeed tables) are created on demand.


## Rake tasks

If you use Rails 2.x, you need to put the following line into your `Rakefile`:

    require 'secret_service/rake_tasks'

If you want to use a specific secret, you can put it into the database by calling

    rake secret_service:store

The secret will be read from STDIN.

To show a previously stored secret, use

    rake secret_service:show SOURCE_SECRET=the_source_secret

where `the_source_secret` is the secret used in the `SecretService.secret(...)` call

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
