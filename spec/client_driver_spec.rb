require 'spec_helper'

describe 'ClientDriver' do
  it_behaves_like 'a client driver'

  subject { FactoryGirl.build(:client_driver) }

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

  describe '#client_type' do
    it { expect(subject.client_type).to be(:none) }
  end

  describe '#magic' do
    it { expect { subject.magic }.to raise_error(NotImplementedError) }
  end

  describe '#get_security_token!' do
    it { expect { subject.get_security_token! }.to raise_error(NotImplementedError) }
  end

  describe '#retire_security_token!' do
    it { expect { subject.retire_security_token! }.to raise_error(NotImplementedError) }
  end
end