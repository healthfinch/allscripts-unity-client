require 'spec_helper'

describe AllscriptsUnityClient::JSONClientDriver do
  it_behaves_like 'a client driver'

  let(:fake_logger) do
    double(Logger)
  end

  before do
    allow(fake_logger).to receive(:info)
  end

  subject do
    client_driver = build(:json_client_driver, logger: fake_logger)
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
    MultiJSON.dump(hash)
  end

  describe '#initialize' do
    context 'when given proxy' do
      it 'passes configuration to connection' do
        expect(build(:json_client_driver, proxy: url).connection.proxy.to_s).to eq(url)
      end
    end
  end

  describe '#client_type' do
    it { expect(subject.client_type).to be(:json) }
  end

  describe '#magic' do
    context 'when the user is authenticated' do
      before do
        stub_request(:post, "http://www.example.com/Unity/UnityService.svc/json/MagicJson").
          to_return(status: 200, body: get_server_info, headers: {})
        allow(subject).to receive(:user_authenticated?).and_return(true)
      end

      it 'should POST to /Unity/UnityService.svc/json/MagicJson' do
        subject.magic
        expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/MagicJson').
          with(body: /\{"Action":(null|"[^"]*"),"AppUserID":(null|"[^"]*"),"Appname":(null|"[^"]*"),"PatientID":(null|"[^"]*"),"Token":(null|"[^"]*"),"Parameter1":(null|"[^"]*"),"Parameter2":(null|"[^"]*"),"Parameter3":(null|"[^"]*"),"Parameter4":(null|"[^"]*"),"Parameter5":(null|"[^"]*"),"Parameter6":(null|"[^"]*"),"Data":(null|"[^"]*")\}/,
               headers: {'Content-Type' => 'application/json'}
              )
      end

      it 'should serialize DateTime to iso8601 when given' do
        subject.magic(parameter1: DateTime.now)
        expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/MagicJson').
          with(body: /\{"Action":(null|"[^"]*"),"AppUserID":(null|"[^"]*"),"Appname":(null|"[^"]*"),"PatientID":(null|"[^"]*"),"Token":(null|"[^"]*"),"Parameter1":"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(-|\+)\d{2}:\d{2}","Parameter2":(null|"[^"]*"),"Parameter3":(null|"[^"]*"),"Parameter4":(null|"[^"]*"),"Parameter5":(null|"[^"]*"),"Parameter6":(null|"[^"]*"),"Data":(null|"[^"]*")\}/,
               headers: { 'Content-Type' => 'application/json' }
              )
      end

      it 'should log the request duration' do
        expect(fake_logger).to receive(:info).with(/Unity API Magic request to [^ ]+ \[SomeRequest\] [0-9.]+ seconds/)

        subject.magic(action: 'SomeRequest')
      end

      it 'should log the response code' do
        expect(fake_logger).to receive(:info).with(/Response Status: 200/)

        subject.magic(action: 'SomeRequest')
      end
    end

    context 'when the user is not authenticated' do
      before do
        stub_request(:post, "http://www.example.com/Unity/UnityService.svc/json/MagicJson").
          to_return(status: 200, body: get_server_info, headers: {})
        allow(subject).to receive(:user_authenticated?).and_return(false)
        subject.options.logger = fake_logger
      end

      it 'logs our unauthenticated request' do
        subject.magic(action: 'SomeRequest')
        expect(fake_logger).to have_received(:info)
                                 .at_least(:once)
                                 .with("Unauthenticated access of SomeRequest for http://www.example.com")
      end
    end
  end

  describe '#get_security_token!' do
    before(:each) {
      stub_request(:post, 'http://www.example.com/Unity/UnityService.svc/json/GetToken').to_return(body: get_security_token)
    }

    it 'should POST to /Unity/UnityService.svc/json/GetToken with username, password, and appname' do
      subject.get_security_token!
      expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/GetToken').with(body: /\{"Username":"[^"]+","Password":"[^"]+","Appname":"[^"]+"\}/, headers: { 'Content-Type' => 'application/json' })
    end

    it 'log the request to get a security token' do
      expect(fake_logger).to receive(:info).with(/Unity API GetSecurityToken request to [^ ]+ [0-9.]+ seconds/)

      subject.get_security_token!
    end

    it 'logs the response code from getting a security token' do
      expect(fake_logger).to receive(:info).with(/Response Status: 200/)

      subject.get_security_token!
    end

    it 'should fail when there is a problem retrieving the security token' do
      stub_request(:post, 'http://www.example.com/Unity/UnityService.svc/json/GetToken')
        .to_return(
          {
            body: "",
            headers: {},
            status: 503,
          }
        )

      expect do
        subject.get_security_token!
      end.to raise_error(AllscriptsUnityClient::GetSecurityTokenError)
    end
  end

  describe '#retire_security_token!' do
    before(:each) {
      stub_request(:post, 'http://www.example.com/Unity/UnityService.svc/json/RetireSecurityToken').to_return(body: retire_security_token)
      allow(subject).to receive(:log_retire_security_token)
      allow(subject).to receive(:revoke_authentication)
    }

    it 'should POST to /Unity/UnityService.svc/json/RetireSecurityToken with token and appname' do
      subject.retire_security_token!
      expect(WebMock).to have_requested(:post, 'http://www.example.com/Unity/UnityService.svc/json/RetireSecurityToken').with(body: /\{"Token":"[^"]+","Appname":"[^"]+"\}/, headers: { 'Content-Type' => 'application/json' })
    end

    it 'should call log_retire_security_token' do
      subject.retire_security_token!
      expect(subject).to have_received(:log_retire_security_token)
    end

    it 'marks the user as unauthenticated' do
      subject.retire_security_token!
      expect(subject).to have_received(:revoke_authentication)
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

  context 'user authentication' do
    context 'when the user is attempting to authenticate' do
      let(:userid) { 'user1' }
      let(:password) { 'password' }

      before do
        # Only return a 'success' response when the right userid,
        # password, and endpoint are used.
        allow(subject).to receive(:magic)
                            .and_return({ valid_user: 'NO' })
        allow(subject).to receive(:magic)
                            .with({action: 'GetUserAuthentication', userid: userid, parameter1: password})
                            .and_return({ valid_user: 'YES' })
        subject.options.ehr_userid = credentials[:ehr_userid]
        subject.options.ehr_password = credentials[:ehr_password]
      end

      context 'with valid credentials' do
        let(:credentials) { { ehr_password: password, ehr_userid: userid } }

        it 'returns a truthy value' do
          expect(subject.get_user_authentication).to be_truthy
        end

        it 'results in the client knowing it is authenticated' do
          subject.get_user_authentication
          expect(subject.user_authenticated?).to be_truthy
        end
      end

      context 'with invalid credentials' do
        let(:credentials) { { ehr_password: 'bad', ehr_userid: 'not me' } }

        it 'returns a falsey value' do
          expect(subject.get_user_authentication).to be_falsey
        end

        it 'results in the client knowing it is not authenticated' do
          subject.get_user_authentication
          expect(subject.user_authenticated?).to be_falsey
        end
      end
    end
  end
end
