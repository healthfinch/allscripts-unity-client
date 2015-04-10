require 'spec_helper'

describe AllscriptsUnityClient::JSONClientDriver do
  it_behaves_like 'a client driver'

  subject do
    client_driver = build(:json_client_driver)
    client_driver.security_token = SecureRandom.uuid
    client_driver
  end

  let(:new_relic_client_driver) { build(:json_client_driver, new_relic: true) }
  let(:get_server_info) { FixtureLoader.load_file('get_server_info.json') }
  let(:get_security_token) { FixtureLoader.load_file('get_security_token.json') }
  let(:retire_security_token) { FixtureLoader.load_file('retire_security_token.json') }
  let(:error) { FixtureLoader.load_json('error.json') }
  let(:error_string) { 'error: Username and Password not valid for any licenses on this server' }
  let(:error_string_2) { 'Error: Your.App is not supported on PM version 10.4.2' }
  let(:url) { Faker::Internet.url }

  let(:hash) do
    {
      'test' => true
    }
  end

  let(:json_hash) do
    Oj.dump(hash, mode: :strict)
  end

  describe '#initialize' do
    context 'when given proxy' do
      it 'passes configuration to connection' do
        expect(build(:json_client_driver, proxy: url).connection.proxy.uri.to_s).to eq(url)
      end
    end
  end

  describe '#client_type' do
    it { expect(subject.client_type).to be(:json) }
  end

  describe '#magic' do
    before(:each) {
      stub_request(:post, 'http://www.example.com/Unity/UnityService.svc/json/MagicJson').to_return(body: get_server_info)
      stub_request(:post, 'http://www.example.com/UnityPM/UnityService.svc/json/MagicJson').to_return(body: get_server_info)
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_magic)
    }

    context "for product: :ehr" do
      it 'should POST to /Unity/UnityService.svc/json/MagicJson' do
        subject.magic
        expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/MagicJson').with(body: /\{"Action":(null|"[^"]*"),"AppUserID":(null|"[^"]*"),"Appname":(null|"[^"]*"),"PatientID":(null|"[^"]*"),"Token":(null|"[^"]*"),"Parameter1":(null|"[^"]*"),"Parameter2":(null|"[^"]*"),"Parameter3":(null|"[^"]*"),"Parameter4":(null|"[^"]*"),"Parameter5":(null|"[^"]*"),"Parameter6":(null|"[^"]*"),"Data":(null|"[^"]*")\}/, headers: { 'Content-Type' => 'application/json' })
      end

      it 'should serialize DateTime to iso8601 when given' do
        subject.magic(parameter1: DateTime.now)
        expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/MagicJson').with(body: /\{"Action":(null|"[^"]*"),"AppUserID":(null|"[^"]*"),"Appname":(null|"[^"]*"),"PatientID":(null|"[^"]*"),"Token":(null|"[^"]*"),"Parameter1":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(-|\+)\d{2}:\d{2}","Parameter2":(null|"[^"]*"),"Parameter3":(null|"[^"]*"),"Parameter4":(null|"[^"]*"),"Parameter5":(null|"[^"]*"),"Parameter6":(null|"[^"]*"),"Data":(null|"[^"]*")\}/, headers: { 'Content-Type' => 'application/json' })
      end
    end
    
    context "for product: :pm" do
      let(:pm_subject) do
        client_driver = build(:json_client_driver, product: :pm)
        client_driver.security_token = SecureRandom.uuid
        client_driver
      end
      
      it 'should POST to /UnityPM/UnityService.svc/json/MagicJson' do
        pm_subject.magic
        expect(WebMock).to have_requested(:post, 'http://www.example.com/UnityPM/UnityService.svc/json/MagicJson').with(body: /\{"Action":(null|"[^"]*"),"AppUserID":(null|"[^"]*"),"Appname":(null|"[^"]*"),"PatientID":(null|"[^"]*"),"Token":(null|"[^"]*"),"Parameter1":(null|"[^"]*"),"Parameter2":(null|"[^"]*"),"Parameter3":(null|"[^"]*"),"Parameter4":(null|"[^"]*"),"Parameter5":(null|"[^"]*"),"Parameter6":(null|"[^"]*"),"Data":(null|"[^"]*")\}/, headers: { 'Content-Type' => 'application/json' })
      end

      it 'should serialize DateTime to iso8601 when given' do
        pm_subject.magic(parameter1: DateTime.now)
        expect(WebMock).to have_requested(:post, 'http://www.example.com/UnityPM/UnityService.svc/json/MagicJson').with(body: /\{"Action":(null|"[^"]*"),"AppUserID":(null|"[^"]*"),"Appname":(null|"[^"]*"),"PatientID":(null|"[^"]*"),"Token":(null|"[^"]*"),"Parameter1":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(-|\+)\d{2}:\d{2}","Parameter2":(null|"[^"]*"),"Parameter3":(null|"[^"]*"),"Parameter4":(null|"[^"]*"),"Parameter5":(null|"[^"]*"),"Parameter6":(null|"[^"]*"),"Data":(null|"[^"]*")\}/, headers: { 'Content-Type' => 'application/json' })
      end
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
      stub_request(:post, 'http://www.example.com/Unity/UnityService.svc/json/GetToken').to_return(body: get_security_token)
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_get_security_token)
    }

    it 'should POST to /Unity/UnityService.svc/json/GetToken with username, password, and appname' do
      subject.get_security_token!
      expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/GetToken').with(body: /\{"Username":"[^"]+","Password":"[^"]+","Appname":"[^"]+"\}/, headers: { 'Content-Type' => 'application/json' })
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
      stub_request(:post, 'http://www.example.com/Unity/UnityService.svc/json/RetireSecurityToken').to_return(body: retire_security_token)
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_retire_security_token)
    }

    it 'should POST to /Unity/UnityService.svc/json/RetireSecurityToken with token and appname' do
      subject.retire_security_token!
      expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/RetireSecurityToken').with(body: /\{"Token":"[^"]+","Appname":"[^"]+"\}/, headers: { 'Content-Type' => 'application/json' })
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

  describe '#raise_if_response_error' do
    context 'when given nil for response' do
      it { expect { subject.send(:raise_if_response_error, nil) }.to raise_error(AllscriptsUnityClient::APIError) }
    end

    context 'when given blank for response' do
      it { expect { subject.send(:raise_if_response_error, '') }.to raise_error(AllscriptsUnityClient::APIError) }
    end

    context 'when given error JSON' do
      it { expect { subject.send(:raise_if_response_error, error) }.to raise_error(AllscriptsUnityClient::APIError) }
    end

    context 'when given error string' do
      it { expect { subject.send(:raise_if_response_error, error_string) }.to raise_error(AllscriptsUnityClient::APIError) }
      it { expect { subject.send(:raise_if_response_error, error_string_2) }.to raise_error(AllscriptsUnityClient::APIError) }
    end
  end

  describe '#build_faraday_options' do
    context 'when given options with ca_file' do
      it 'sets ca_file' do
        client_driver = build(:json_client_driver, ca_file: 'test_file')
        expect(client_driver.send(:build_faraday_options)[:ssl][:ca_file]).to eq('test_file')
      end
    end

    context 'when given options with ca_path' do
      it 'sets ca_path' do
        client_driver = build(:json_client_driver, ca_path: 'test_path')
        expect(client_driver.send(:build_faraday_options)[:ssl][:ca_path]).to eq('test_path')
      end
    end

    context 'when given options with nil ca_file and ca_path' do
      it 'calls JSONClientDriver.find_ca_file' do
        allow(AllscriptsUnityClient::JSONClientDriver).to receive(:find_ca_file).and_return('/test/file')
        expect(subject.send(:build_faraday_options)[:ssl][:ca_file]).to eq('/test/file')
      end
    end

    context 'when given options with nil ca_file, ca_path, and JSONClientDriver.find_ca_file returns nil' do
      it 'calls JSONClientDriver.find_ca_file' do
        allow(AllscriptsUnityClient::JSONClientDriver).to receive(:find_ca_file).and_return(nil)
        allow(AllscriptsUnityClient::JSONClientDriver).to receive(:find_ca_path).and_return('/test/path')
        expect(subject.send(:build_faraday_options)[:ssl][:ca_path]).to eq('/test/path')
      end
    end
  end

  describe '.find_ca_path' do
    context 'when Ubuntu certs path is found' do
      it 'returns the Ubuntu certs path' do
        allow(File).to receive(:directory?).with('/usr/lib/ssl/certs').and_return(true)
        expect(AllscriptsUnityClient::JSONClientDriver.send(:find_ca_path)).to eq('/usr/lib/ssl/certs')
      end
    end

    context 'when no certificate path is found' do
      it 'returns nil' do
        allow(File).to receive(:directory?).with('/usr/lib/ssl/certs').and_return(false)
        expect(AllscriptsUnityClient::JSONClientDriver.send(:find_ca_path)).to be_nil
      end
    end
  end

  describe '.find_ca_file' do
    context 'when OS X ca-bundle.crt found' do
      it 'returns the ca-bundle.crt' do
          allow(File).to receive(:exists?).with('/opt/boxen/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt').and_return(true)
          expect(AllscriptsUnityClient::JSONClientDriver.send(:find_ca_file)).to eq('/opt/boxen/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt')
      end
    end

    context 'when OS X curl-ca-bundle.crt found' do
      it 'returns the curl-ca-bundle.crt' do
        allow(File).to receive(:exists?).with('/opt/boxen/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt').and_return(false)
        allow(File).to receive(:exists?).with('/opt/local/share/curl/curl-ca-bundle.crt').and_return(true)
        expect(AllscriptsUnityClient::JSONClientDriver.send(:find_ca_file)).to eq('/opt/local/share/curl/curl-ca-bundle.crt')
      end
    end

    context 'when CentOS ca-certificates.crt found' do
      it 'returns the curl-ca-bundle.crt' do
        allow(File).to receive(:exists?).with('/opt/boxen/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt').and_return(false)
        allow(File).to receive(:exists?).with('/opt/local/share/curl/curl-ca-bundle.crt').and_return(false)
        allow(File).to receive(:exists?).with('/usr/lib/ssl/certs/ca-certificates.crt').and_return(true)
        expect(AllscriptsUnityClient::JSONClientDriver.send(:find_ca_file)).to eq('/usr/lib/ssl/certs/ca-certificates.crt')
      end
    end

    context 'when no certificate file is found' do
      it 'returns nil' do
        allow(File).to receive(:exists?).with('/opt/boxen/homebrew/opt/curl-ca-bundle/share/ca-bundle.crt').and_return(false)
        allow(File).to receive(:exists?).with('/opt/local/share/curl/curl-ca-bundle.crt').and_return(false)
        allow(File).to receive(:exists?).with('/usr/lib/ssl/certs/ca-certificates.crt').and_return(false)
        expect(AllscriptsUnityClient::JSONClientDriver.send(:find_ca_file)).to be_nil
      end
    end
  end

  describe '.set_request_timeout' do
    context 'when given options with timeout set' do
      it 'sets timeout and open_timeout on the request' do
        client_driver = build(:json_client_driver, timeout: 10)
        options = {}
        request = double('request', options: options)
        client_driver.send(:set_request_timeout, request)
        expect(options[:timeout]).to eq(10)
        expect(options[:open_timeout]).to eq(10)
      end
    end

    context 'when given options without timeout set' do
      it 'sets timeout and open_timeout to 90 on the request' do
        options = {}
        request = double('request', options: options)
        subject.send(:set_request_timeout, request)
        expect(options[:timeout]).to eq(90)
        expect(options[:open_timeout]).to eq(90)
      end
    end
  end
end