require 'spec_helper'

describe 'UnityResponse' do
  subject(:unity_response) { FactoryGirl.build(:unity_response) }

  let(:attributes_hash) do
    {
      :"@attribute1" => {
        :"@nested_attribute1" => true,
        :normal_key => true
      },
      :"@attribute2" => true,
      :normal_key_2 => true,
      :array_of_attributes => [
        { :"@attribute" => true, :value => { :"@attribute" => true, :value => true } },
        { :"@attribute" => true, :value => true },
        { :"@attribute" => true, :value => true }
      ]
    }
  end

  let(:stripped_attributes_hash) do
    {
      :normal_key_2 => true,
      :array_of_attributes => [
        { :value => { :value => true } },
        { :value => true },
        { :value => true }
      ]
    }
  end

  let(:date_hash) do
    {
      :date_string => "2013-02-15",
      :date_string2 => {
        :value => "2013-02-15"
      },
      :date_array => [
        "2013-02-15",
        "2013-02-15",
        "2013-02-15"
      ]
    }
  end

  let(:converted_date_hash) do
    {
      :date_string => Date.parse("2013-02-15"),
      :date_string2 => {
        :value => Date.parse("2013-02-15")
      },
      :date_array => [
        Date.parse("2013-02-15"),
        Date.parse("2013-02-15"),
        Date.parse("2013-02-15")
      ]
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
          magic_response = FactoryGirl.build(:magic_response_soap)
          magic_response[:magic_response][:magic_result][:diffgram] = nil
          unity_response = FactoryGirl.build(:unity_response, :response => magic_response)
          expect(unity_response.to_hash).to eq([])
        end
      end
    end
  end

  describe '#strip_attributes' do
    context 'when given nil' do
      it { expect(unity_response.send(:strip_attributes, nil)).to be_nil }
    end

    it 'recursively strips attribute keys off hashes' do
      expect(unity_response.send(:strip_attributes, attributes_hash)).to eq(stripped_attributes_hash)
    end
  end

  describe '#convert_dates_to_utc' do
    context 'when given nil' do
      it { expect(unity_response.send(:convert_dates_to_utc, nil)).to be_nil }
    end

    it 'recursively converts date strings' do
      expect(unity_response.send(:convert_dates_to_utc, date_hash)).to eq(converted_date_hash)
    end
  end
end