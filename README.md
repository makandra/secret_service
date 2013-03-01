# SecretService

SecretService allows you to store random secrets in your app (for example the session secret or other shared secrets) more securely.

It does this by distributing the actual secret between your code and your database. That is, the final secret can only be calculated if you know both the secret given in your code and a secret stored in your database. The database part is generated randomly on first use.

As a useful sideeffect this means your different environments (staging / production) will automatically use different secrets.


It only works for *random* secrets though, you cannot use it to store access tokens or the like.


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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
