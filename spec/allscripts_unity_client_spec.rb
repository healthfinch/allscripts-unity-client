require 'spec_helper'

describe 'AllscriptsUnityClient' do
  include Savon::SpecHelper

  subject { AllscriptsUnityClient }

  let(:get_security_token) { FixtureLoader.load_file("get_security_token.xml") }

  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }

  describe '.create' do
    context 'when given :mode => :soap' do
      it 'returns a SOAPClient' do
        savon.expects("GetSecurityToken").with(:message => :any).returns(get_security_token)
        parameters = FactoryGirl.build(:allscripts_unity_client_parameters, :mode => :soap)
        expect(subject.create(parameters).client_type).to be(:soap)
      end
    end

    context 'when given :mode => :json' do
      it 'returns a JSONClient' do
        stub_request(:post, "http://www.example.com/Unity/UnityService.svc/json/GetToken")
        parameters = FactoryGirl.build(:allscripts_unity_client_parameters, :mode => :json)
        expect(subject.create(parameters).client_type).to be(:json)
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