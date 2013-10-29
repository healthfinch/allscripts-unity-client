require 'spec_helper'

describe 'UnityResponse' do
  it_behaves_like 'a unity response'

  subject(:unity_response) { FactoryGirl.build(:unity_response, :response => magic_response_soap) }

  let(:magic_response_soap) do
    {
      :magic_response => {
        :magic_result => {
          :schema => {
            :element => {
              :complex_type => {
                :choice => {
                  :element => {
                    :complex_type => {
                      :sequence => {
                        :element => [
                          {
                            :@name => "ServerTimeZone",
                            :@type => "xs:string",
                            :@min_occurs => "0"
                          },
                          {
                            :@name => "ServerTime",
                            :@type => "xs:string",
                            :@min_occurs => "0"
                          },
                          {
                            :@name => "ServerDateTimeOffset",
                            :@type => "xs:string",
                            :@min_occurs => "0"
                          },
                          {
                            :@name => "System",
                            :@type => "xs:string",
                            :@min_occurs => "0"
                          },
                          {
                            :@name => "ProductVersion",
                            :@type => "xs:string",
                            :@min_occurs => "0"
                          },
                          {
                            :@name => "uaibornondate",
                            :@type => "xs:string",
                            :@min_occurs => "0"
                          }
                        ]
                      }
                    },
                    :@name => "getserverinfoinfo"
                    },
                    :@min_occurs => "0",
                    :@max_occurs => "unbounded"
                  }
                },
                :@name => "getserverinforesponse",
                :"@msdata:is_data_set" => "true",
                :"@msdata:use_current_locale" => "true"
              },
              :"@xmlns:xs" => "http://www.w3.org/2001/XMLSchema",
              :@xmlns => "",
              :"@xmlns:msdata" => "urn:schemas-microsoft-com:xml-msdata",
              :@id => "getserverinforesponse"
          },
          :diffgram => {
            :getserverinforesponse => {
              :getserverinfoinfo => {
                :server_time_zone => "Eastern Standard Time",
                :server_time => DateTime.parse("2013-10-24T18:52:49+00:00"),
                :server_date_time_offset => DateTime.parse("2013-10-24T18:52:49-04:00"),
                :system => "Enterprise EHR",
                :product_version => "11.2.3.32.000",
                :uaibornondate => "10/07/2013",
                :"@diffgr:id" => "getserverinfoinfo1",
                :"@msdata:row_order" => "0"
              },
              :@xmlns => ""
            },
            :"@xmlns:diffgr" => "urn:schemas-microsoft-com:xml-diffgram-v1",
            :"@xmlns:msdata" => "urn:schemas-microsoft-com:xml-msdata"
          }
        },
        :@xmlns => "http://www.allscripts.com/Unity"
      }
    }
  end

  describe '#initialize' do
    context 'when nil is given for response' do
      it { expect { FactoryGirl.build(:unity_response, :response => nil) }.to raise_error(ArgumentError) }
    end

    context 'when nil is given for timezone' do
      it { expect { FactoryGirl.build(:unity_response, :timezone => nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#to_hash' do
    context 'when given a GetServerInfo SOAP response hash' do
      it 'strips Unity SOAP wrappers' do
        expect(unity_response.to_hash[:server_time_zone]).to_not be_nil
      end

      context 'when given nil magic_result' do
        it 'returns []' do
          magic_response = magic_response_soap
          magic_response[:magic_response][:magic_result][:diffgram] = nil
          unity_response.response = magic_response
          expect(unity_response.to_hash).to eq([])
        end
      end
    end
  end
end