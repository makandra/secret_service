# SecretService

SecretService allows you to store secrets in your Rails app (for example the
session secret or other shared secrets) more securely.

It does this by distributing the actual secret between your code and your
database. That is, the final secret can only be calculated if you know both the
secret given in your code and a secret stored in your database.

Secrets can either be generated randomly on first use, or set using the
Raketask.


## How it works

SecretService uses the secret given in your code (the "source secret") to
encrypt/decrypt a corresponding secret stored in the database. The source
secrets is also used to identify the database secret to be used (but is hashed
for this purpose).

As a useful side effect, different environments (staging / production) will
automatically have different secrets. You also cannot accidentally copy secrets
from one project to another.

SecretService will create a database table called "secret_service_secrets".
This happens automatically on first use.

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

You will probably want to use this in your
`config/initializers/secret_token.rb` initializer.

The database entries (and indeed tables) are created on demand.


## Rake tasks

If you use Rails 2.x, you need to put the following line into your `Rakefile`:

    require 'secret_service/rake_tasks'

If you want to use a specific secret, you can put it into the database by calling

    rake secret_service:store

The source secret you'll put into your code as well as the actual secret are
read from STDIN. You can leave the first one blank to have it generated
automatically.

To show a previously stored secret, use

    rake secret_service:show

where `the_source_secret` is the secret used in the `SecretService.secret(...)`
call.


## Capistrano integration

To get capistrano integration, put this into your `config/deploy.rb`:

    require 'secret_service/capistrano'

You'll get the two rake tasks as corresponding capistrano tasks:

    cap secret_service:store
    cap secret_service:show


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run tests by calling `rake all:bundle` first, then just `rake`. Tests will
   be run against Rails 2.3, 3.0 and 3.2.
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request


## Credits

Tobias Kraze, [makandra](http://makandra.com)
