namespace :secret_service do
  desc 'Store a desired secret in the database'
  task :store => :environment do
    store = SecretService::Store.new

    puts "Enter source secret (as given in your source code; leave blank to auto-generate):"
    source_secret = STDIN.gets.chomp

    if source_secret == ''
      source_secret = store.generate_secret
    end

    puts "Enter secret:"
    final_secret = STDIN.gets.chomp

    store.set(source_secret, final_secret)

    puts "We're done!"
    puts
    puts "Retrieve this secret in your app using"
    puts "  SecretService.secret(#{source_secret.inspect})"
    puts
  end

  desc 'Show a previously stored secret'
  task :show => :environment do
    store = SecretService::Store.new
    puts "Enter source secret (as given in your source code):"
    source_secret = STDIN.gets.chomp

    secret = store.get(source_secret, :only_existing => true)
    if secret
      puts "Secret: ", secret
    else
      puts "Secret not stored"
    end
    puts
  end

end
