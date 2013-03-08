require 'spec_helper'

describe SecretService::Store do


  def store
    SecretService::Store.send(:new)
  end

  describe '#get' do

    it 'should return long secrets' do
      store.get('foo').size.should > 20
    end

    it 'should consistently return the same secret' do
      store.get('foobar').should == store.get('foobar')
    end

    it 'should not return the same secret for different source secrets' do
      store.get('foo').should_not == store.get('bar')
    end

    it 'should not contain the source secret' do
      store.get('foobarbaz').should_not include('foobarbaz')
    end

    it 'should return a different secret when the database changes' do
      first_secret = store.get('foo')
      SecretServiceSpec.wipe_store
      store.get('foo').should_not == first_secret
    end

    it 'should not put the source secret into the database' do
      store.get('foobarbaz')
      secret_record = SecretService::DatabaseStore::ActiveRecordStore::Secret.first
      secret_record.key.should_not include('foobarbaz')
      secret_record.value.should_not include('foobarbaz')
    end

    it 'should not put the final secret into the database' do
      final_secret = store.get('foobarbaz')
      secret_record = SecretService::DatabaseStore::ActiveRecordStore::Secret.first
      secret_record.key.should_not include(final_secret)
      secret_record.value.should_not include(final_secret)
    end

    it 'should put long secrets into the database' do
      store.get('foobarbaz')
      secret_record = SecretService::DatabaseStore::ActiveRecordStore::Secret.first
      secret_record.value.size.should > 10
    end

    context ':only_existing => true' do

      it 'should not make a new secret' do
        store.get('foobar', :only_existing => true).should be_nil
      end

      it 'should retrieve an existing secret' do
        secret = store.get('foobar')
        store.get('foobar', :existing => true).should == secret
      end

    end

    context 'concurrency' do

      def safe_fork
        reader, writer = IO.pipe
        fork do
          ActiveRecord::Base.connection.reconnect!
          reader.close
          yield(writer)
          writer.flush
          writer.close
          Process.exit!
        end
        writer.close
        ActiveRecord::Base.connection.reconnect!
        reader
      end


      it 'should work concurrently' do
        readers = []
        20.times do
          readers << safe_fork do |writer|
            sleep rand(0.1)
            writer.print store.get("foobar")
          end
        end
        lines = readers.collect(&:read)
        lines.size.should == 20
        lines.uniq.should == [store.get("foobar")]
      end

    end

  end

  describe '#set' do

    it 'should set the final secret to a given value' do
      source_secret = 'a6df546'
      store.set(source_secret, 'final secret')
      store.get(source_secret).should == 'final secret'
    end

  end

  describe '#generate_secret' do

    it 'should return a random secret' do
      store.generate_secret.should_not == store.generate_secret
    end

    it 'should return a long secret' do
      store.generate_secret.size.should > 20
    end

  end

end
