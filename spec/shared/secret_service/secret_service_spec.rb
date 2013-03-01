require 'spec_helper'

describe SecretService do

  describe '.secret' do

    it 'should delegate to the store' do
      SecretService::Store.instance.should_receive(:get).with('source secret').and_return('final secret')
      SecretService.secret('source secret').should == 'final secret'
    end

    it 'should cache' do
      SecretService::Store.instance.should_receive(:get).exactly(:once).and_return('final secret')
      SecretService.secret('source secret')
      SecretService.secret('source secret')
    end

    it 'should return the source secret if :plain is true' do
      SecretService.secret('source secret', :plain => true).should == 'source secret'
    end

  end

end
