require 'spec_helper'

describe AllscriptsUnityClient::ClientOptions do
  subject { build(:client_options) }

  let(:url_with_slash) { 'http://www.example.com/' }
  let(:url_without_slash) { 'http://www.example.com' }
  let(:utc_timezone) { AllscriptsUnityClient::Timezone.new('UTC') }
  let(:america_los_angeles) { 'America/Los_Angeles' }
  let(:america_los_angeles_timezone) { AllscriptsUnityClient::Timezone.new('America/Los_Angeles') }
  let(:client_options_hash) { { base_unity_url: 'http://www.example.com', username: 'username', password: 'password', appname: 'appname', proxy: 'proxy', timezone: 'UTC', logger: nil } }

  describe '#validate_options' do
    context 'when not given base_unity_url' do
      it { expect { build(:client_options, base_unity_url: nil) }.to raise_error(ArgumentError) }
    end

    context 'when not given username' do
      it { expect { build(:client_options, username: nil) }.to raise_error(ArgumentError) }
    end

    context 'when not given password' do
      it { expect { build(:client_options, password: nil) }.to raise_error(ArgumentError) }
    end

    context 'when not given appname' do
      it { expect { build(:client_options, appname: nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#base_unity_url=' do
    context 'when given a base_unity_url that ends in a slash (/)' do
      it 'strips the slash' do
        subject.base_unity_url = url_with_slash
        expect(subject.base_unity_url).to eq(url_without_slash)
      end
    end

    context 'when given nil' do
      it { expect { subject.base_unity_url = nil }.to raise_error(ArgumentError) }
    end
  end

  describe '#username=' do
    context 'when given nil' do
      it { expect { subject.username = nil }.to raise_error(ArgumentError) }
    end

    context 'when given username' do
      it { expect { subject.username = 'username' }.not_to raise_error }
    end
  end

  describe '#password=' do
    context 'when given nil' do
      it { expect { subject.password = nil }.to raise_error(ArgumentError) }
    end

    context 'when given password' do
      it { expect { subject.password = 'password' }.not_to raise_error }
    end
  end

  describe '#appname=' do
    context 'when given nil' do
      it { expect { subject.appname = nil }.to raise_error(ArgumentError) }
    end

    context 'when given appname' do
      it { expect { subject.appname = 'appname' }.not_to raise_error }
    end
  end

  describe '#timezone=' do
    context 'when given nil' do
      it 'sets timezone to UTC' do
        subject.timezone = nil
        expect(subject.timezone).to eq(utc_timezone)
      end
    end

    context 'when given tzinfo string' do
      it 'sets it to correct Timezone' do
        subject.timezone = america_los_angeles
        expect(subject.timezone).to eq(america_los_angeles_timezone)
      end
    end
  end

  describe '#proxy?' do
    context 'when proxy is nil' do
      it 'returns false' do
        expect(subject.proxy?).to be_falsey
      end
    end

    context 'when proxy is not nil' do
      it 'returns true' do
        subject.proxy = url_with_slash
        expect(subject.proxy?).to be_truthy
      end
    end

    context 'when proxy is empty string' do
      it 'returns false' do
        subject.proxy = ''
        expect(subject.proxy?).to be_falsey
      end
    end
  end

  describe '#logger?' do
    context 'when logger is nil' do
      it 'returns false' do
        expect(subject.logger?).to be_falsey
      end
    end

    context 'when logger is not nil' do
      it 'returns true' do
        subject.logger = double('logger')
        expect(subject.logger?).to be_truthy
      end
    end
  end

  describe '#ca_file?' do
    context 'when ca_file is nil' do
      it 'returns false' do
        expect(subject.ca_file?).to be_falsey
      end
    end

    context 'when ca_file is not nil' do
      it 'returns true' do
        subject.ca_file = 'test_file'
        expect(subject.ca_file?).to be_truthy
      end
    end

    context 'when ca_file is empty string' do
      it 'returns false' do
        subject.ca_file = ''
        expect(subject.ca_file?).to be_falsey
      end
    end
  end

  describe '#ca_path?' do
    context 'when ca_path is nil' do
      it 'returns false' do
        expect(subject.ca_path?).to be_falsey
      end
    end

    context 'when ca_path is not nil' do
      it 'returns true' do
        subject.ca_path = 'test_path'
        expect(subject.ca_path?).to be_truthy
      end
    end

    context 'when ca_path is empty string' do
      it 'returns false' do
        subject.ca_path = ''
        expect(subject.ca_path?).to be_falsey
      end
    end
  end

  describe '#timeout?' do
    context 'when timeout is nil' do
      it 'returns false' do
        expect(subject.timeout?).to be_falsey
      end
    end

    context 'when timeout is not nil' do
      it 'returns true' do
        subject.timeout = 10
        expect(subject.timeout?).to be_truthy
      end
    end
  end

  describe '#new_relic?' do
    context 'when new_relic is nil' do
      it 'returns false' do
        subject.new_relic = nil
        expect(subject.new_relic?).to be_falsey
      end
    end

    context 'when timeout is not nil' do
      it 'returns true' do
        subject.new_relic = true
        expect(subject.new_relic?).to be_truthy
      end
    end
  end
end