require 'spec_helper'

describe AllscriptsUnityClient::JSONUnityResponse do
  it_behaves_like 'a unity response'

  subject { build(:json_unity_response, response: get_server_info) }

  let(:get_server_info) { FixtureLoader.load_yaml('get_server_info_json.yml') }
  let(:get_providers) { FixtureLoader.load_yaml('get_providers_json.yml') }

  describe '#initialize' do
    context 'when nil is given for response' do
      it { expect { build(:json_unity_response, response: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for timezone' do
      it { expect { build(:json_unity_response, timezone: nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#to_hash' do
    context 'when given a GetServerInfo JSON response hash' do
      it 'strips Unity JSON wrappers' do
        expect(subject.to_hash[:server_time_zone]).to_not be_nil
      end
    end

    context 'when given empty response' do
      it 'returns []' do
        magic_response = get_providers
        magic_response[0]['getprovidersinfo'] = []
        subject.response = magic_response
        expect(subject.to_hash).to eq([])
      end
    end

    context 'when given a multiple item response' do
      it 'returns an array' do
        subject.response = get_providers
        expect(subject.to_hash).to be_instance_of(Array)
      end
    end
  end
end
