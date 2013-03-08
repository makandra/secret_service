namespace :secret_service do

  def _run_with_prompt(command)
    run command do |input, stream, out|
      puts out
      if stream == :out and out =~ /^Enter/
        input.send_data STDIN.gets
      end
    end
  end

  desc "Store a secret using secret_service"
  task :store, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")

    _run_with_prompt("cd #{current_path} && #{rake} RAILS_ENV=#{rails_env} secret_service:store")
  end

  desc "Show a secret previously stored with secret_service"
  task :show, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")

    _run_with_prompt("cd #{current_path} && #{rake} RAILS_ENV=#{rails_env} secret_service:show")
  end
end
