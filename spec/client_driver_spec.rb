require 'spec_helper'

describe AllscriptsUnityClient::ClientDriver do
  it_behaves_like 'a client driver'

  subject { build(:client_driver) }
  let(:new_relic_client_driver) { build(:client_driver, new_relic: true) }

  describe '#client_type' do
    it { expect(subject.client_type).to be(:none) }
  end

  describe '#magic' do
    it { expect { subject.magic }.to raise_error(NotImplementedError) }
  end

  describe '#get_security_token!' do
    it { expect { subject.get_security_token! }.to raise_error(NotImplementedError) }
  end

  describe '#retire_security_token!' do
    it { expect { subject.retire_security_token! }.to raise_error(NotImplementedError) }
  end
end