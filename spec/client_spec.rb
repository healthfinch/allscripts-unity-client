require 'spec_helper'

describe 'Client' do
  subject { FactoryGirl.build(:client) }

  describe '#initialize' do
    context 'when given nil for client_driver' do
      it { expect { FactoryGirl.build(:client, :client_driver => nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#magic' do
    it 'calls magic on @client_driver' do
      subject.client_driver = double(:magic => "magic")
      subject.magic
      expect(subject.client_driver).to have_received(:magic)
    end
  end

  describe '#get_security_token!' do
    it 'calls get_security_token! on @client_driver' do
      subject.client_driver = double(:get_security_token! => "get_security_token!")
      subject.get_security_token!
      expect(subject.client_driver).to have_received(:get_security_token!)
    end
  end

  describe '#retire_security_token!' do
    it 'calls retire_security_token! on @client_driver' do
      subject.client_driver = double(:retire_security_token! => "retire_security_token!")
      subject.retire_security_token!
      expect(subject.client_driver).to have_received(:retire_security_token!)
    end
  end

  describe '#security_token?' do
    it 'calls security_token? on @client_driver' do
      subject.client_driver = double(:security_token? => "security_token?")
      subject.security_token?
      expect(subject.client_driver).to have_received(:security_token?)
    end
  end

  describe '#client_type' do
    it 'calls client_type on @client_driver' do
      subject.client_driver = double(:client_type => "client_type?")
      subject.client_type
      expect(subject.client_driver).to have_received(:client_type)
    end
  end
end