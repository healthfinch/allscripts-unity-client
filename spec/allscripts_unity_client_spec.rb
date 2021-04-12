require 'spec_helper'

describe AllscriptsUnityClient do
  subject { described_class }

  describe '#create' do
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

    context 'when given raw_dates true' do
      it 'returns a client with client_type :json' do
        parameters = build(:allscripts_unity_client_parameters, mode: :json, raw_dates: true)
        client = subject.create(parameters)
        expect(client.client_type).to be(:json)
      end
    end

    context 'when given raw_dates false' do
      it 'returns a client with client_type :json' do
        parameters = build(:allscripts_unity_client_parameters, mode: :json, raw_dates: false)
        client = subject.create(parameters)
        expect(client.client_type).to be(:json)
      end
    end

    context 'when not given raw_dates' do
      it 'returns a json client with raw_dates option defaulted to false' do
        parameters = build(:allscripts_unity_client_parameters, mode: :json)
        client = subject.create(parameters)
        expect(client.options.raw_dates).to be_falsy
        expect(client.client_type).to be(:json)
      end
    end
  end

  describe '#save_task' do
    it 'raises when each of transaction_id, delegate_id, and comment are nil' do
      parameters = build(:allscripts_unity_client_parameters, mode: :json)

      client = subject.create(parameters)

      expect do
        client.save_task(:user_id, :patient_id)
      end.to raise_error(ArgumentError)
    end
  end

  describe '#save_task_status' do
    it 'raises when each of transaction_id, delegate_id, and comment are nil' do
      parameters = build(:allscripts_unity_client_parameters, mode: :json)
      client = subject.create(parameters)
      allow_any_instance_of(AllscriptsUnityClient::JSONClientDriver)
        .to receive(:user_authenticated?).and_return(true)

      expect do
        client.save_task_status(:user_id, :patient_id)
      end.to raise_error(ArgumentError)
    end

    it 'maintains a nil parameter6 whenever taskchanges is nil' do
      parameters = build(:allscripts_unity_client_parameters, mode: :json)
      client = subject.create(parameters)

      def client.magic(params)
        params
      end

      result = client.save_task_status(1, 1, :status, 1, :comment, nil, 1)

      expect(result[:parameter6]).to eq("")
    end
  end
end
