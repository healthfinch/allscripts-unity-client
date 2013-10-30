require 'spec_helper'

describe 'Utilities' do
  subject { AllscriptsUnityClient::Utilities }

  let(:date_string) { '2013-02-15' }
  let(:date) { Date.parse(date_string) }
  let(:datetime_string) { '2013-02-15T00:00:00Z' }
  let(:datetime) { DateTime.parse(datetime_string) }

  let(:string) { 'string' }
  let(:string_array) { ['string'] }
  let(:base64_string) { "c3RyaW5n\n" }

  let(:hash) do
    {
      "key1" => true,
      "key2" => {
        "key3" => true
      },
      "key4" => [
        { "key5" => true },
        { "key6" => true },
        { "key7" => true }
      ]
    }
  end

  let(:symbolized_hash) do
    {
      :key1 => true,
      :key2 => {
        :key3 => true
      },
      :key4 => [
        { :key5 => true },
        { :key6 => true },
        { :key7 => true }
      ]
    }
  end

  describe '.try_to_encode_as_date' do
    context 'when given nil' do
      it { expect(subject.try_to_encode_as_date(nil)).to be_nil }
    end

    context 'when given date string' do
      it 'returns the string as a Date' do
        expect(subject.try_to_encode_as_date(date_string)).to eq(date)
      end
    end

    context 'when given date time string' do
      it 'returns the string as a DateTime' do
        expect(subject.try_to_encode_as_date(datetime_string)).to eq(datetime)
      end
    end

    context 'when given a non-date string' do
      it 'returns that string' do
        expect(subject.try_to_encode_as_date(string)).to eq(string)
      end
    end
  end

  describe '.encode_data' do
    context 'when given nil' do
      it { expect(subject.encode_data(nil)).to be_nil }
    end

    context 'when given a string' do
      it 'returns a base64 encoded version of that string' do
        expect(subject.encode_data(string)).to eq(base64_string)
      end
    end

    context 'when given an array of strings' do
      it 'returns a base64 encoded version of that string' do
        expect(subject.encode_data(string_array)).to eq(base64_string)
      end
    end
  end

  describe '.recursively_symbolize_keys' do
    context 'when given nil' do
      it { expect(subject.recursively_symbolize_keys(nil)).to be_nil }
    end

    context 'when given a hash with string keys' do
      it { expect(subject.recursively_symbolize_keys(hash)).to eq(symbolized_hash) }
    end
  end
end