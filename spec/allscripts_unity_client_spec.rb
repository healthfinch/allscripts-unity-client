require 'spec_helper'

describe AllscriptsUnityClient do
  include Savon::SpecHelper

  subject { described_class }

  describe '.create' do
    context 'when given mode: :soap' do
      it 'returns a SOAPClient' do
        parameters = build(:allscripts_unity_client_parameters, mode: :soap)
        expect(subject.create(parameters).client_type).to be(:soap)
      end
    end

    context 'when given mode: :json' do
      it 'returns a client with client_type :json' do
        parameters = build(:allscripts_unity_client_parameters, mode: :json)
        expect(subject.create(parameters).client_type).to be(:json)
      end
    end

    context 'when not given :mode' do
      it 'returns a client with client_type :soap' do
        parameters = build(:allscripts_unity_client_parameters)
        parameters[:mode] = nil
        expect(subject.create(parameters).client_type).to be(:soap)
      end
    end
  end

  describe '.raise_if_options_invalid' do
    context 'when not given :mode' do
      it { expect { subject.send(:raise_if_options_invalid, build(:allscripts_unity_client_parameters, mode: nil)) }.to raise_error(ArgumentError) }
    end

    context 'when given mode: :json' do
      it { expect { subject.send(:raise_if_options_invalid, build(:allscripts_unity_client_parameters, mode: :json)) }.not_to raise_error }
    end

    context 'when given mode: :soap' do
      it { expect { subject.send(:raise_if_options_invalid, build(:allscripts_unity_client_parameters, mode: :soap)) }.not_to raise_error }
    end
  end
end