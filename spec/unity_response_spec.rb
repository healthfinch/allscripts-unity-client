require 'spec_helper'

describe 'UnityResponse' do
  it_behaves_like 'a unity response'

  subject { FactoryGirl.build(:unity_response, response: get_server_info) }

  let(:get_server_info) { FixtureLoader.load_yaml('get_server_info_xml.yml') }

  describe '#initialize' do
    context 'when nil is given for response' do
      it { expect { FactoryGirl.build(:unity_response, response: nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for timezone' do
      it { expect { FactoryGirl.build(:unity_response, timezone: nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#to_hash' do
    context 'when given a GetServerInfo SOAP response hash' do
      it 'strips Unity SOAP wrappers' do
        expect(subject.to_hash[:server_time_zone]).to_not be_nil
      end

      context 'when given nil magic_result' do
        it 'returns []' do
          magic_response = get_server_info
          magic_response[:magic_response][:magic_result][:diffgram] = nil
          subject.response = magic_response
          expect(subject.to_hash).to eq([])
        end
      end
    end
  end
end