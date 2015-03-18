require 'spec_helper'

describe AllscriptsUnityClient do
  subject { described_class }

  describe '.create' do
    context 'when given mode: :json' do
      it 'returns a client with client_type :json' do
        parameters = build(:allscripts_unity_client_parameters, mode: :json)
        expect(subject.create(parameters).client_type).to be(:json)
      end
    end

    context 'when not given :mode' do
      it 'returns a client with client_type :json' do
        parameters = build(:allscripts_unity_client_parameters)
        parameters[:mode] = nil
        expect(subject.create(parameters).client_type).to be(:json)
      end
    end

    context 'when given an invalid :mode' do
      it 'raises an argument error' do
        parameters = build(:allscripts_unity_client_parameters)
        parameters[:mode] = :cheese
        expect { subject.create(parameters) }.to raise_error(ArgumentError, ':mode must be :json')
      end
    end
  end
end
