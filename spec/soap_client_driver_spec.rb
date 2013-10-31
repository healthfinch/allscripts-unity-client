require 'spec_helper'

describe 'SOAPClientDriver' do
  include Savon::SpecHelper
  it_behaves_like 'a client driver'

  subject do
    client_driver = FactoryGirl.build(:soap_client_driver)
    client_driver.security_token = SecureRandom.uuid
    client_driver
  end

  let(:get_server_info) { FixtureLoader.load_file("get_server_info.xml") }
  let(:get_security_token) { FixtureLoader.load_file("get_security_token.xml") }
  let(:retire_security_token) { FixtureLoader.load_file("retire_security_token.xml") }
  let(:soap_fault) { FixtureLoader.load_file("soap_fault.xml") }
  let(:url) { Faker::Internet.url }

  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }

  describe '#initialize' do
    context 'when nil is given for base_unity_url' do
      it { expect { FactoryGirl.build(:soap_client_driver, :base_unity_url => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for username' do
      it { expect { FactoryGirl.build(:soap_client_driver, :username => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for password' do
      it { expect { FactoryGirl.build(:soap_client_driver, :password => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for appname' do
      it { expect { FactoryGirl.build(:soap_client_driver, :appname => nil) }.to raise_error(ArgumentError) }
    end

    context 'when given a base_unity_url with a trailing /' do
      it 'sets @base_unity_url without the trailing /' do
        client_driver = FactoryGirl.build(:soap_client_driver, :base_unity_url => "http://www.example.com/")
        expect(client_driver.base_unity_url).to eq("http://www.example.com")
      end
    end

    context 'when nil is given for timezone' do
      it 'sets @timezone to UTC' do
        client_driver = FactoryGirl.build(:soap_client_driver, :timezone => nil)
        utc_timezone = FactoryGirl.build(:timezone, :zone_identifier => "UTC")
        expect(client_driver.timezone.tzinfo).to eq(utc_timezone.tzinfo)
      end
    end

    context 'when nil is given for proxy' do
      it 'sets Savon proxy option to nil' do
        client_driver = FactoryGirl.build(:soap_client_driver, :proxy => nil)
        expect(client_driver.savon_client.globals.instance_variable_get("@options")[:proxy]).to be_nil
      end
    end

    context 'when proxy is given' do
      it 'sets Savon proxy option to the given url' do
        client_driver = FactoryGirl.build(:soap_client_driver, :proxy => url)
        expect(client_driver.savon_client.globals.instance_variable_get("@options")[:proxy]).to eq(url)
      end
    end

    context 'when nil is given for logger' do
      it 'sets @logger to Logger' do
        client_driver = FactoryGirl.build(:client_driver, :logger => nil)
        expect(client_driver.logger).to be_instance_of(Logger)
      end
    end

    context 'when logger is set' do
      it 'sets @logger to logger' do
        logger = double("logger")
        client_driver = FactoryGirl.build(:client_driver, :logger => logger)
        expect(client_driver.logger).to be(logger)
      end
    end
  end

  describe '#client_type' do
    it { expect(subject.client_type).to be(:soap) }
  end

  describe '#magic' do
    before(:each) {
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_magic)
    }

    it 'should send a SOAP request to Magic endpoint' do
      savon.expects("Magic").with(:message => :any).returns(get_server_info)
      subject.magic
    end

    context 'when a Savon::SOAPFault is raised' do
      it 'should raise an APIError' do
        savon.expects("Magic").with(:message => :any).returns({ code: 500, headers: {}, body: soap_fault })
        expect { subject.magic }.to raise_error(AllscriptsUnityClient::APIError)
      end
    end

    it 'should call start_timer' do
      savon.expects("Magic").with(:message => :any).returns(get_server_info)
      subject.magic
      expect(subject).to have_received(:start_timer)
    end

    it 'should call end_timer' do
      savon.expects("Magic").with(:message => :any).returns(get_server_info)
      subject.magic
      expect(subject).to have_received(:start_timer)
    end

    it 'should call log_magic' do
      savon.expects("Magic").with(:message => :any).returns(get_server_info)
      subject.magic
      expect(subject).to have_received(:log_magic)
    end
  end

  describe '#get_security_token!' do
    before(:each) {
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_get_security_token)
    }

    it 'should send a SOAP request to GetSecurityToken endpoint' do
      savon.expects("GetSecurityToken").with(:message => :any).returns(get_security_token)
      subject.get_security_token!
    end

    context 'when a Savon::SOAPFault is raised' do
      it 'should raise an APIError' do
        savon.expects("GetSecurityToken").with(:message => :any).returns({ code: 500, headers: {}, body: soap_fault })
        expect { subject.get_security_token! }.to raise_error(AllscriptsUnityClient::APIError)
      end
    end

    it 'should call start_timer' do
      savon.expects("GetSecurityToken").with(:message => :any).returns(get_security_token)
      subject.get_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call end_timer' do
      savon.expects("GetSecurityToken").with(:message => :any).returns(get_security_token)
      subject.get_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call log_get_security_token' do
      savon.expects("GetSecurityToken").with(:message => :any).returns(get_security_token)
      subject.get_security_token!
      expect(subject).to have_received(:log_get_security_token)
    end
  end

  describe '#retire_security_token!' do
    before(:each) {
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_retire_security_token)
    }

    it 'should send a SOAP request to RetireSecurityToken endpoint' do
      savon.expects("RetireSecurityToken").with(:message => :any).returns(retire_security_token)
      subject.retire_security_token!
    end

    context 'when a Savon::SOAPFault is raised' do
      it 'should raise an APIError' do
        savon.expects("RetireSecurityToken").with(:message => :any).returns({ code: 500, headers: {}, body: soap_fault })
        expect { subject.retire_security_token! }.to raise_error(AllscriptsUnityClient::APIError)
      end
    end

    it 'should call start_timer' do
      savon.expects("RetireSecurityToken").with(:message => :any).returns(retire_security_token)
      subject.retire_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call end_timer' do
      savon.expects("RetireSecurityToken").with(:message => :any).returns(retire_security_token)
      subject.retire_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call log_retire_security_token' do
      savon.expects("RetireSecurityToken").with(:message => :any).returns(retire_security_token)
      subject.retire_security_token!
      expect(subject).to have_received(:log_retire_security_token)
    end
  end
end