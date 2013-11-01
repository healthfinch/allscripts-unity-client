require 'spec_helper'

describe 'AllscriptsUnityClient' do
  include Savon::SpecHelper

  subject { AllscriptsUnityClient }

  describe '.create' do
    context 'when given :mode => :soap' do
      it 'returns a SOAPClient' do
        parameters = FactoryGirl.build(:allscripts_unity_client_parameters, :mode => :soap)
        expect(subject.create(parameters).client_type).to be(:soap)
      end
    end

    context 'when given :mode => :json' do
      it 'returns a client with client_type :json' do
        parameters = FactoryGirl.build(:allscripts_unity_client_parameters, :mode => :json)
        expect(subject.create(parameters).client_type).to be(:json)
      end
    end

    context 'when not given :mode' do
      it 'returns a client with client_type :soap' do
        parameters = FactoryGirl.build(:allscripts_unity_client_parameters)
        parameters[:mode] = nil
        expect(subject.create(parameters).client_type).to be(:soap)
      end
    end
  end

  describe '.raise_if_parameters_invalid' do
    context 'when not given :base_unity_url' do
      it { expect { subject.send(:raise_if_parameters_invalid, FactoryGirl.build(:allscripts_unity_client_parameters, :base_unity_url => nil)) }.to raise_error(ArgumentError) }
    end

    context 'when not given :username' do
      it { expect { subject.send(:raise_if_parameters_invalid, FactoryGirl.build(:allscripts_unity_client_parameters, :username => nil)) }.to raise_error(ArgumentError) }
    end

    context 'when not given :password' do
      it { expect { subject.send(:raise_if_parameters_invalid, FactoryGirl.build(:allscripts_unity_client_parameters, :password => nil)) }.to raise_error(ArgumentError) }
    end

    context 'when not given :appname' do
      it { expect { subject.send(:raise_if_parameters_invalid, FactoryGirl.build(:allscripts_unity_client_parameters, :appname => nil)) }.to raise_error(ArgumentError) }
    end
  end
end