require 'spec_helper'
require 'open3'

describe 'Rake tasks' do

  def execute_rake(task, options = {})
    env = "BUNDLE_GEMFILE=#{File.expand_path(File.join(Rails.root, '..', 'Gemfile'))}"
    options.fetch(:env, {}).each do |key, value|
      env << " #{key}=#{value}"
    end
    # this is the only way I could make it work in ruby 1.8 and 1.9
    Open3.popen3("bash -c 'cd #{Rails.root}; #{env} bundle exec rake #{task}'") do |stdin, stdout, stderr, wait_thr|
      if options[:puts]
        stdin.puts options[:puts]
      end
      stdin.close
      error = stderr.read
      STDERR.puts error if error.present?
      stdout.read
    end
  ensure
    ActiveRecord::Base.connection.reconnect!
  end


  describe 'store' do

    it 'should store the prompted secret under the given key' do
      output = execute_rake('secret_service:store', :puts => 'the_secret')
      (output =~ /SecretService\.secret\("(.*)"\)/).should be_true
      SecretService.secret($1).should == 'the_secret'
    end

    it 'should allow to set the source secret' do
      output = execute_rake('secret_service:store', :env => {'SOURCE_SECRET' => 'source_secret'}, :puts => 'the_secret')
      output.should =~ /SecretService\.secret\("source_secret"\)/
    end

  end

  describe 'show' do

    it 'should show a previously stored secret' do
      SecretService::Store.new.set('source_secret', 'secret_secret')
      output = execute_rake('secret_service:show', :env => {'SOURCE_SECRET' => 'source_secret'})
      output.should =~ /secret_secret/
    end

    it 'should not store a new secret' do
      output = execute_rake('secret_service:show', :env => {'SOURCE_SECRET' => 'source_secret'})
      SecretService::Store.new.get('source_secret', :only_existing => true).should be_nil
    end

    it 'should tell if the secret does not exist' do
      output = execute_rake('secret_service:show', :env => {'SOURCE_SECRET' => 'source_secret'})
      output.should =~ /Secret not stored/
    end
  end


end
