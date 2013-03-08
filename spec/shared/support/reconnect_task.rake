namespace :secret_service do
  namespace :test do
    desc 'Reconnect AR'
    task :reconnect => :environment do
      # necessary on ruby 1.8, the specs run our rake tasks using fork, which is not safe for AR
      ActiveRecord::Base.reconnect!
    end
  end
end
