shared_examples 'a client driver' do
  describe '#security_token?' do
    context 'when @security_token is nil' do
      it do
        subject.security_token = nil
        expect(subject.security_token?).to be_false
      end
    end

    context 'when @security_token is not nil' do
      it do
        subject.security_token = "security token"
        expect(subject.security_token?).to be_true
      end
    end
  end
end