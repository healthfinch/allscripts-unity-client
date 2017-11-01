require 'spec_helper'

describe AllscriptsUnityClient::UnityRequest do
  it_behaves_like 'a unity request'

  subject { build(:unity_request) }

  describe '#initialize' do
    context 'when nil is given for parameters' do
      it { expect { build(:unity_request, parameters: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for timezone' do
      it { expect { build(:unity_request, timezone: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for appname' do
      it { expect { build(:unity_request, appname: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for security_token' do
      it { expect { build(:unity_request, security_token: nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#to_hash' do
    it ':userid maps to UserID' do
      subject.parameters = build(:magic_request, userid: 'UserID')
      expect(subject.to_hash['UserID']).to eq('UserID')
    end

    it ':data maps to Base64 encoded data' do
      subject.parameters = build(:magic_request, data: 'data')
      expect(subject.to_hash['data']).to eq(['data'].pack('m'))
    end
  end
end
