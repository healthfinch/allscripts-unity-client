require 'spec_helper'

describe 'Timezone' do
  subject { FactoryGirl.build(:timezone) }

  let(:positive_timezone) { FactoryGirl.build(:timezone, :zone_identifier => "Asia/Jakarta") }
  let(:utc_timezone) { FactoryGirl.build(:timezone, :zone_identifier => "UTC") }
  let(:local_string) { "2013-10-19T17:00:00-07:00" }
  let(:date) { Date.parse(local_string) }
  let(:local_time) { Time.parse("2013-10-19T17:00:00") }
  let(:local_datetime) { DateTime.parse(local_string) }
  let(:utc_string) { "2013-10-20T00:00:00+00:00" }
  let(:utc_time) { Time.parse("2013-10-20T00:00:00") }
  let(:utc_datetime) { DateTime.parse(utc_string) }

  def time_to_s(time)
    time.strftime("%FT%T")
  end

  describe '#initialize' do
    context 'when nil is given' do
      it 'raises ArgumentError' do
        expect { FactoryGirl.build(:timezone, :zone_identifier => nil) }.to raise_error(ArgumentError)
      end
    end

    context 'when an invalid TZInfo zone is given' do
      it 'rasies TZInfo::InvalidTimezoneIdentifier' do
        expect { FactoryGirl.build(:timezone, :zone_identifier => "") }.to raise_error(TZInfo::InvalidTimezoneIdentifier)
      end
    end
  end

  describe '#local_to_utc' do
    it 'calls #convert_with_timezone with :local_to_utc' do
      allow(subject).to receive(:convert_with_timezone).and_return(local_string)
      subject.local_to_utc(local_string)
      expect(subject).to have_received(:convert_with_timezone).with(:local_to_utc, local_string)
    end
  end

  describe '#utc_to_local' do
    it 'calls #convert_with_timezone with :utc_to_local' do
      allow(subject).to receive(:convert_with_timezone).and_return(local_string)
      subject.utc_to_local(local_string)
      expect(subject).to have_received(:convert_with_timezone).with(:utc_to_local, local_string)
    end
  end

  describe '#convert_with_timezone' do
    context 'when given nil' do
      it { expect(subject.send(:convert_with_timezone, nil)).to be_nil }
    end

    context 'when given :local_to_utc and a Date' do
      it 'returns a Date' do
        expect(subject.send(:convert_with_timezone, :local_to_utc, date)).to be_an_instance_of(Date)
      end
    end

    context 'when given :local_to_utc and a Time' do
      it 'returns a Date' do
        expect(subject.send(:convert_with_timezone, :local_to_utc, local_time)).to be_an_instance_of(Time)
      end
    end

    context 'when given :local_to_utc and a DateTime' do
      it 'returns a DateTime' do
        expect(subject.send(:convert_with_timezone, :local_to_utc, local_datetime)).to be_an_instance_of(DateTime)
      end
    end

    context 'when given :local_to_utc and a String' do
      it 'returns a DateTime' do
        expect(subject.send(:convert_with_timezone, :local_to_utc, local_string)).to be_an_instance_of(DateTime)
      end
    end

    context 'when given :utc_to_local and a Date' do
      it 'returns a Date' do
        expect(subject.send(:convert_with_timezone, :utc_to_local, date)).to be_an_instance_of(Date)
      end
    end

    context 'when given :utc_to_local and a Time' do
      it 'returns a Date' do
        expect(subject.send(:convert_with_timezone, :utc_to_local, utc_time)).to be_an_instance_of(Time)
      end
    end

    context 'when given :utc_to_local and a DateTime' do
      it 'returns a DateTime' do
        expect(subject.send(:convert_with_timezone, :utc_to_local, utc_datetime)).to be_an_instance_of(DateTime)
      end
    end

    context 'when given :utc_to_local and a String' do
      it 'returns a DateTime' do
        expect(subject.send(:convert_with_timezone, :utc_to_local, utc_string)).to be_an_instance_of(DateTime)
      end
    end

    describe 'converts local time to UTC' do
      context 'when given an ISO8601 date string' do
        it { expect(subject.send(:convert_with_timezone, :local_to_utc, local_string)).to eq(utc_datetime) }
      end

      context 'when given a Date' do
        it { expect(subject.send(:convert_with_timezone, :local_to_utc, date)).to eq(date) }
      end

      context 'when given a local Time' do
        it { expect(time_to_s(subject.send(:convert_with_timezone, :local_to_utc, local_time))).to eq(time_to_s(utc_time)) }
      end

      context 'when given a local DateTime' do
        it { expect(subject.send(:convert_with_timezone, :local_to_utc, local_datetime)).to eq(utc_datetime) }
      end
    end

    describe 'converts UTC time to local' do
      context 'when given an ISO8601 date string' do
        it { expect(subject.send(:convert_with_timezone, :utc_to_local, utc_string)).to eq(local_datetime) }
      end

      context 'when given a Date' do
        it { expect(subject.send(:convert_with_timezone, :utc_to_local, date)).to eq(date) }
      end

      context 'when given a local Time' do
        it { expect(time_to_s(subject.send(:convert_with_timezone, :utc_to_local, utc_time))).to eq(time_to_s(local_time)) }
      end

      context 'when given a local DateTime' do
        it { expect(subject.send(:convert_with_timezone, :utc_to_local, utc_datetime)).to eq(local_datetime) }
      end
    end
  end

  describe "#iso8601_with_offset" do
    context 'when given nil' do
      it 'returns nil' do
        expect(subject.send(:iso8601_with_offset, nil)).to be_nil
      end
    end

    describe 'appends correct ISO8601 timezone offset string' do
      context 'when UTC' do
        it { expect(utc_timezone.send(:iso8601_with_offset, utc_datetime)).to match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/) }
      end

      context 'when timezone offset is negative' do
        it { expect(subject.send(:iso8601_with_offset, utc_datetime)).to match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}-07:00$/) }
      end

      context 'when timezone offset is positive' do
        it { expect(positive_timezone.send(:iso8601_with_offset, utc_datetime)).to match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+07:00$/) }
      end
    end
  end
end