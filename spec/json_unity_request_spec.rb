require 'spec_helper'

describe AllscriptsUnityClient::JSONUnityRequest do
  it_behaves_like 'a unity request'

  subject { build(:json_unity_request) }

  describe '#initialize' do
    context 'when nil is given for parameters' do
      it { expect { build(:json_unity_request, parameters: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for timezone' do
      it { expect { build(:json_unity_request, timezone: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for appname' do
      it { expect { build(:json_unity_request, appname: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for security_token' do
      it { expect { build(:json_unity_request, security_token: nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#to_hash' do
    it ':userid maps to AppUserID' do
      subject.parameters = build(:magic_request, userid: 'UserID')
      expect(subject.to_hash['AppUserID']).to eq('UserID')
    end

    it ':data maps to Base64 encoded Data' do
      subject.parameters = build(:magic_request, data: 'data')
      expect(subject.to_hash['Data']).to eq(['data'].pack('m'))
    end
  end
end