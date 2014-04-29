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
        subject.security_token = 'security token'
        expect(subject.security_token?).to be_true
      end
    end
  end

  describe '#log_get_security_token' do
    it 'should call log_info' do
      allow(subject).to receive(:log_info)
      subject.send(:log_get_security_token)
      expect(subject).to have_received(:log_info)
    end
  end

  describe '#log_retire_security_token' do
    it 'should call log_info' do
      allow(subject).to receive(:log_info)
      subject.send(:log_retire_security_token)
      expect(subject).to have_received(:log_info)
    end
  end

  describe '#log_magic' do
    it 'should call log_info' do
      allow(subject).to receive(:log_info)
      subject.send(:log_magic, double(parameters: { action: 'action'}))
      expect(subject).to have_received(:log_info)
    end

    context 'when given nil for request' do
      it { expect { subject.send(:log_magic, nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#log_info' do
    context 'when @options.logger? is true' do
      it 'should call @options.logger.info' do
        subject.options.logger = double('logger', info: true)
        subject.send(:log_info, 'test')
        expect(subject.options.logger).to have_received(:info)
      end
    end

    context 'when @options.logger? is false' do
      it 'should not call @options.logger.info' do
        allow_message_expectations_on_nil
        subject.options.logger = nil
        allow(subject.options.logger).to receive(:info)
        subject.send(:log_info, 'test')
        expect(subject.options.logger).not_to have_received(:info)
      end
    end

    context 'when given nil for message' do
      it 'should not call @options.logger.info' do
        subject.options.logger = double('logger', info: true)
        subject.send(:log_info, nil)
        expect(subject.options.logger).not_to have_received(:info)
      end
    end

    context 'when @options.logger? is false' do
      it 'should not call @logger.info' do
        expect { subject.send(:log_info, 'test') }.not_to raise_error
      end
    end

    context 'when @timer is nil and @options.logger is true' do
      it 'should not include seconds in the log' do
        subject.options.logger = double('logger', info: true)
        subject.instance_variable_set('@timer', nil)
        subject.send(:log_info, 'test')
        expect(subject.options.logger).not_to have_received(:info).with(match(/seconds/))
      end
    end

    context 'when @timer is not nil and @options.logger? is true' do
      it 'should include seconds in log' do
        subject.options.logger = double('logger', info: true)
        subject.instance_variable_set('@timer', 1.2)
        subject.send(:log_info, 'test')
        expect(subject.options.logger).to have_received(:info).with(match(/seconds/))
      end
    end
  end

  describe '#start_timer' do
    it 'sets @start_time' do
      subject.send(:start_timer)
      expect(subject.instance_variable_get('@start_time')).not_to be_nil
    end
  end

  describe '#end_timer' do
    it 'sets @end_time' do
      subject.send(:start_timer)
      subject.send(:end_timer)
      expect(subject.instance_variable_get('@end_time')).not_to be_nil
    end

    it 'sets @timer to @end_time - @start_time' do
      subject.send(:start_timer)
      subject.send(:end_timer)
      expect(subject.instance_variable_get('@timer')).to eq(subject.instance_variable_get('@end_time') - subject.instance_variable_get('@start_time'))
    end
  end
end