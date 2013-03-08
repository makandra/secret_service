require 'spec_helper'

describe SecretService do

  describe '.secret' do

    let(:store) { double('store') }

    before do
      SecretService::Store.stub :new => store
    end

    it 'should delegate to the store' do
      store.should_receive(:get).with('source secret').and_return('final secret')
      SecretService.secret('source secret').should == 'final secret'
    end

    it 'should cache' do
      store.should_receive(:get).exactly(:once).and_return('final secret')
      SecretService.secret('source secret')
      SecretService.secret('source secret')
    end

  end

end
