require 'spec_helper'

describe 'JSONClientDriver' do
  it_behaves_like 'a client driver'

  subject do
    client_driver = FactoryGirl.build(:json_client_driver)
    client_driver.security_token = SecureRandom.uuid
    client_driver
  end

  let(:get_server_info) { FixtureLoader.load_file("get_server_info.json") }
  let(:get_security_token) { FixtureLoader.load_file("get_security_token.json") }
  let(:retire_security_token) { FixtureLoader.load_file("retire_security_token.json") }
  let(:error) { FixtureLoader.load_json("error.json") }
  let(:error_string) { "error: Username and Password not valid for any licenses on this server" }
  let(:url) { Faker::Internet.url }

  let(:hash) do
    {
      "test" => true
    }
  end

  let(:json_hash) do
    JSON.generate(hash)
  end

  describe '#initialize' do
    context 'when nil is given for base_unity_url' do
      it { expect { FactoryGirl.build(:json_client_driver, :base_unity_url => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for username' do
      it { expect { FactoryGirl.build(:json_client_driver, :username => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for password' do
      it { expect { FactoryGirl.build(:json_client_driver, :password => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for appname' do
      it { expect { FactoryGirl.build(:json_client_driver, :appname => nil) }.to raise_error(ArgumentError) }
    end

    context 'when given a base_unity_url with a trailing /' do
      it 'sets @base_unity_url without the trailing /' do
        client_driver = FactoryGirl.build(:json_client_driver, :base_unity_url => "http://www.example.com/")
        expect(client_driver.base_unity_url).to eq("http://www.example.com")
      end
    end

    context 'when nil is given for timezone' do
      it 'sets @timezone to UTC' do
        client_driver = FactoryGirl.build(:json_client_driver, :timezone => nil)
        utc_timezone = FactoryGirl.build(:timezone, :zone_identifier => "UTC")
        expect(client_driver.timezone.tzinfo).to eq(utc_timezone.tzinfo)
      end
    end

    context 'when nil is given for logger' do
      it 'sets @logger to Logger' do
        client_driver = FactoryGirl.build(:json_client_driver, :logger => nil)
        expect(client_driver.logger).to be_instance_of(Logger)
      end
    end

    context 'when logger is set' do
      it 'sets @logger to logger' do
        logger = double("logger")
        client_driver = FactoryGirl.build(:json_client_driver, :logger => logger)
        expect(client_driver.logger).to be(logger)
      end
    end
  end

  describe '#client_type' do
    it { expect(subject.client_type).to be(:json) }
  end

  describe '#magic' do
    before(:each) {
      stub_request(:post, "http://www.example.com/Unity/UnityService.svc/json/MagicJson").to_return(:body => get_server_info)
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_magic)
    }

    it 'should POST to /Unity/UnityService.svc/json/MagicJson' do
      subject.magic
      WebMock.should have_requested(:post, "http://www.example.com/Unity/UnityService.svc/json/MagicJson")
    end

    it 'should call start_timer' do
      subject.magic
      expect(subject).to have_received(:start_timer)
    end

    it 'should call end_timer' do
      subject.magic
      expect(subject).to have_received(:start_timer)
    end

    it 'should call log_magic' do
      subject.magic
      expect(subject).to have_received(:log_magic)
    end
  end

  describe '#get_security_token!' do
    before(:each) {
      stub_request(:post, "http://www.example.com/Unity/UnityService.svc/json/GetToken").to_return(:body => get_security_token)
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_get_security_token)
    }

    it 'should POST to /Unity/UnityService.svc/json/GetToken' do
      subject.get_security_token!
      WebMock.should have_requested(:post, "http://www.example.com/Unity/UnityService.svc/json/GetToken")
    end

    it 'should call start_timer' do
      subject.get_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call end_timer' do
      subject.get_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call log_get_security_token' do
      subject.get_security_token!
      expect(subject).to have_received(:log_get_security_token)
    end
  end

  describe '#retire_security_token!' do
    before(:each) {
      stub_request(:post, "http://www.example.com/Unity/UnityService.svc/json/RetireSecurityToken").to_return(:body => retire_security_token)
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_retire_security_token)
    }

    it 'should POST to /Unity/UnityService.svc/json/RetireSecurityToken' do
      subject.retire_security_token!
      WebMock.should have_requested(:post, "http://www.example.com/Unity/UnityService.svc/json/RetireSecurityToken")
    end

    it 'should call start_timer' do
      subject.retire_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call end_timer' do
      subject.retire_security_token!
      expect(subject).to have_received(:start_timer)
    end

    it 'should call log_retire_security_token' do
      subject.retire_security_token!
      expect(subject).to have_received(:log_retire_security_token)
    end
  end

  describe '#create_httpi_request' do
    context 'when given url' do
      it 'returns an HTTPI request with that url' do
        expect(subject.send(:create_httpi_request, url, hash).url.to_s).to eq(url)
      end
    end

    context 'when given data' do
      it 'returns an HTTPI request with body set to that data' do
        expect(subject.send(:create_httpi_request, url, hash).body).to eq(json_hash)
      end
    end

    context 'when @proxy is nil' do
      it 'returns an HTTPI request with proxy set to nil' do
        subject.proxy = nil
        expect(subject.send(:create_httpi_request, url, hash).proxy).to be_nil
      end
    end

    context 'when @proxy is set' do
      it 'return an HTTPI request with proxy set to @proxy' do
        subject.proxy = url
        expect(subject.send(:create_httpi_request, url, hash).proxy.to_s).to eq(url)
      end
    end
  end

  describe '#raise_if_response_error' do
    context 'when given nil for response' do
      it { expect { subject.send(:raise_if_response_error, nil) }.to raise_error(AllscriptsUnityClient::APIError) }
    end

    context 'when given error JSON' do
      it { expect { subject.send(:raise_if_response_error, error) }.to raise_error(AllscriptsUnityClient::APIError) }
    end

    context 'when given error string' do
      it { expect { subject.send(:raise_if_response_error, error_string) }.to raise_error(AllscriptsUnityClient::APIError) }
    end
  end
end