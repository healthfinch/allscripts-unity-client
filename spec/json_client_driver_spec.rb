require 'spec_helper'

describe 'JSONClientDriver' do
  it_behaves_like 'a client driver'

  subject do
    client_driver = build(:json_client_driver)
    client_driver.security_token = SecureRandom.uuid
    client_driver
  end

  let(:get_server_info) { FixtureLoader.load_file('get_server_info.json') }
  let(:get_security_token) { FixtureLoader.load_file('get_security_token.json') }
  let(:retire_security_token) { FixtureLoader.load_file('retire_security_token.json') }
  let(:error) { FixtureLoader.load_json('error.json') }
  let(:error_string) { 'error: Username and Password not valid for any licenses on this server' }
  let(:url) { Faker::Internet.url }

  let(:hash) do
    {
      'test' => true
    }
  end

  let(:json_hash) do
    JSON.generate(hash)
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
      allow(subject).to receive(:start_timer)
      allow(subject).to receive(:end_timer)
      allow(subject).to receive(:log_magic)
    }

    it 'should POST to /Unity/UnityService.svc/json/MagicJson' do
      subject.magic
      expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/MagicJson').with(body: /\{"Action":(null|"[^"]*"),"AppUserID":(null|"[^"]*"),"Appname":(null|"[^"]*"),"PatientID":(null|"[^"]*"),"Token":(null|"[^"]*"),"Parameter1":(null|"[^"]*"),"Parameter2":(null|"[^"]*"),"Parameter3":(null|"[^"]*"),"Parameter4":(null|"[^"]*"),"Parameter5":(null|"[^"]*"),"Parameter6":(null|"[^"]*"),"Data":(null|"[^"]*")\}/, headers: { 'Content-Type' => 'application/json' })
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

    context 'when given error JSON' do
      it { expect { subject.send(:raise_if_response_error, error) }.to raise_error(AllscriptsUnityClient::APIError) }
    end

    context 'when given error string' do
      it { expect { subject.send(:raise_if_response_error, error_string) }.to raise_error(AllscriptsUnityClient::APIError) }
    end
  end
end