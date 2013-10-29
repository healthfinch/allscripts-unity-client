require 'spec_helper'

describe 'JSONUnityResponse' do
  it_behaves_like 'a unity response'

  subject(:unity_response) { FactoryGirl.build(:json_unity_response, :response => magic_response_json) }

  let(:magic_response_json) do
    [
      {
        "getserverinfoinfo" => [
          {
            "ServerDateTimeOffset" => "2013-10-29T10:32:42.6932000-04:00",
            "ServerTime" => "2013-10-29T10:32:42",
            "uaibornondate" => "10/07/2013",
            "ProductVersion" => "11.2.3.32.000",
            "System" => "Enterprise EHR",
            "ServerTimeZone" => "Eastern Standard Time"
          }
        ]
      }
    ]
  end

  let(:magic_response_json_array) do
    [
      {
        "getserverinfoinfo" => [
          {
            "ServerDateTimeOffset" => "2013-10-29T10:32:42.6932000-04:00",
            "ServerTime" => "2013-10-29T10:32:42",
            "uaibornondate" => "10/07/2013",
            "ProductVersion" => "11.2.3.32.000",
            "System" => "Enterprise EHR",
            "ServerTimeZone" => "Eastern Standard Time"
          },
          {
            "ServerDateTimeOffset" => "2013-10-29T10:32:42.6932000-04:00",
            "ServerTime" => "2013-10-29T10:32:42",
            "uaibornondate" => "10/07/2013",
            "ProductVersion" => "11.2.3.32.000",
            "System" => "Enterprise EHR",
            "ServerTimeZone" => "Eastern Standard Time"
          }
        ]
      }
    ]
  end

  describe '#initialize' do
    context 'when nil is given for response' do
      it { expect { FactoryGirl.build(:json_unity_response, :response => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for timezone' do
      it { expect { FactoryGirl.build(:json_unity_response, :timezone => nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#to_hash' do
    context 'when given a GetServerInfo JSON response hash' do
      it 'strips Unity JSON wrappers' do
        expect(unity_response.to_hash[:server_time_zone]).to_not be_nil
      end

      context 'when given empty response' do
        it 'returns []' do
          unity_response.response = []
          expect(unity_response.to_hash).to eq([])
        end
      end

      context 'when given a multiple item response' do
        it 'returns an array' do
          unity_response.response = magic_response_json_array
          expect(unity_response.to_hash).to be_instance_of(Array)
        end
      end
    end
  end
end