require 'spec_helper'

describe 'ClientDriver' do
  subject(:client_driver) { FactoryGirl.build(:client_driver) }

  describe '#initialize' do
    context 'when nil is given for base_unity_url' do
      it { expect { FactoryGirl.build(:client_driver, :base_unity_url => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for username' do
      it { expect { FactoryGirl.build(:client_driver, :username => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for password' do
      it { expect { FactoryGirl.build(:client_driver, :password => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for appname' do
      it { expect { FactoryGirl.build(:client_driver, :appname => nil) }.to raise_error(ArgumentError) }
    end

    context 'when given a base_unity_url with a trailing /' do
      it 'sets @base_unity_url without the trailing /' do
        client_driver = FactoryGirl.build(:client_driver, :base_unity_url => "http://www.example.com/")
        expect(client_driver.base_unity_url).to eq("http://www.example.com")
      end
    end

    context 'when nil is given for timezone' do
      it 'sets @timezone to UTC' do
        client_driver = FactoryGirl.build(:client_driver, :timezone => nil)
        utc_timezone = FactoryGirl.build(:timezone, :zone_identifier => "UTC")
        expect(client_driver.timezone.tzinfo).to eq(utc_timezone.tzinfo)
      end
    end
  end

  describe '#security_token?' do
    context 'when @security_token is nil' do
      it do
        client_driver.security_token = nil
        expect(client_driver.security_token?).to be_false
      end
    end

    context 'when @security_token is not nil' do
      it do
        client_driver.security_token = "security token"
        expect(client_driver.security_token?).to be_true
      end
    end
  end

  describe '#client_type' do
    it { expect(client_driver.client_type).to be(:none) }
  end

  describe '#magic' do
    it { expect { client_driver.magic }.to raise_error(NotImplementedError) }
  end

  describe '#get_security_token!' do
    it { expect { client_driver.get_security_token! }.to raise_error(NotImplementedError) }
  end

  describe '#retire_security_token!' do
    it { expect { client_driver.retire_security_token! }.to raise_error(NotImplementedError) }
  end
end