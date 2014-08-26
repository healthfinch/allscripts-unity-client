require 'spec_helper'

describe AllscriptsUnityClient::Utilities do
  subject { described_class }

  let(:date_string) { '2013-02-15' }
  let(:date) { Date.parse(date_string) }
  let(:datetime_string) { '2013-02-15T00:00:00Z' }
  let(:datetime) { DateTime.parse(datetime_string) }

  let(:string) { 'string' }
  let(:string_array) { ['string'] }
  let(:base64_string) { "c3RyaW5n\n" }

  let(:string_keyed_hash) { FixtureLoader.load_yaml('string_keyed_hash.yml') }
  let(:symbol_keyed_hash) { FixtureLoader.load_yaml('symbol_keyed_hash.yml') }

  let(:datetime_string_one) { 'Feb 27 2013 12:37PM' }
  let(:datetime_string_two) { 'Feb 28 2013  1:34PM' }
  let(:datetime_string_three) { '12/25/2013 12:37 PM' }
  let(:datetime_string_four) { 'Nov  1 2011 11:31AM' }
  let(:datetime_one) { DateTime.parse(datetime_string_one) }
  let(:datetime_two) { DateTime.parse(datetime_string_two) }
  let(:datetime_three) { DateTime.parse(datetime_string_three) }
  let(:datetime_four) { DateTime.parse(datetime_string_four) }
  let(:date_string_one) { '20-Jul-2014' }
  let(:date_string_two) { '12/25/2013' }
  let(:date_string_three) { 'Nov  1 2011' }
  let(:date_one) { Date.parse(date_string_one) }
  let(:date_two) { Date.parse(date_string_two) }
  let(:date_three) { Date.parse(date_string_three) }

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

    context 'when given datetime_string_one' do
      it 'returns the string as a DateTime' do
        expect(subject.try_to_encode_as_date(datetime_string_one)).to eq(datetime_one)
      end
    end

    context 'when given datetime_string_two' do
      it 'returns the string as a DateTime' do
        expect(subject.try_to_encode_as_date(datetime_string_two)).to eq(datetime_two)
      end
    end

    context 'when given datetime_string_three' do
      it 'returns the string as a DateTime' do
        expect(subject.try_to_encode_as_date(datetime_string_three)).to eq(datetime_three)
      end
    end

    context 'when given datetime_string_four' do
      it 'returns the string as a DateTime' do
        expect(subject.try_to_encode_as_date(datetime_string_four)).to eq(datetime_four)
      end
    end

    context 'when given date_string_one' do
      it 'returns the string as a Date' do
        expect(subject.try_to_encode_as_date(date_string_one)).to eq(date_one)
      end
    end

    context 'when given date_string_two' do
      it 'returns the string as a Date' do
        expect(subject.try_to_encode_as_date(date_string_two)).to eq(date_two)
      end
    end

    context 'when given date_string_three' do
      it 'returns the string as a Date' do
        expect(subject.try_to_encode_as_date(date_string_three)).to eq(date_three)
      end
    end

    context 'when given a non-date string' do
      it 'returns that string' do
        expect(subject.try_to_encode_as_date(string)).to eq(string)
      end
    end
    
    context 'when given an americanized dash-delimited date string' do
      it 'returns the valid date' do
        expect(subject.try_to_encode_as_date('01-25-2012')).to eq(Date.parse('2012-1-25'))
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
      it { expect(subject.recursively_symbolize_keys(string_keyed_hash)).to eq(symbol_keyed_hash) }
    end
  end
end