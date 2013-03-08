require 'spec_helper'
require 'open3'

describe 'Rake tasks' do

  def execute_rake(task, options = {})
    env = ENV.to_hash
    env.merge!('BUNDLE_GEMFILE' => File.expand_path(File.join(Rails.root, '..', 'Gemfile')))
    env.merge!(options.fetch(:env, {}))
    Open3.popen2(env, "bundle exec rake #{task}", :chdir => Rails.root) do |stdin, stdout, wait_thr|
      if options[:puts]
        stdin.puts options[:puts]
      end
      stdin.close
      stdout.read
    end
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
