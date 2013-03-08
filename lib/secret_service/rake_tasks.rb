namespace :secret_service do
  desc 'Store a desired secret in the database'
  task :store => :environment do
    store = SecretService::Store.new
    source_secret = ENV['SOURCE_SECRET'] || store.generate_secret

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
    source_secret = ENV['SOURCE_SECRET']

    if source_secret
      secret = store.get(source_secret, :only_existing => true)
      if secret
        puts "Secret: ", secret
      else
        puts "Secret not stored"
      end
      puts
    else
      puts "Specify the given source secret with SOURCE_SECRET=..."
      puts
      fail
    end
  end

end
