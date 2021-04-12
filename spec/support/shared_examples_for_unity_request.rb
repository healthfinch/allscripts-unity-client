shared_examples 'a unity request' do
  let(:magic_request) { build(:magic_request) }

  describe '#to_hash' do
    it ':action maps to Action' do
      subject.parameters = build(:magic_request, action: 'Action')
      expect(subject.to_hash['Action']).to eq('Action')
    end

    it ':appname maps to Appname' do
      subject.parameters = build(:magic_request, appname: 'Appname')
      expect(subject.to_hash['Appname']).to eq('Appname')
    end

    it ':patientid maps to PatientID' do
      subject.parameters = build(:magic_request, patientid: 'PatientID')
      expect(subject.to_hash['PatientID']).to eq('PatientID')
    end

    it ':token maps to Token' do
      subject.parameters = build(:magic_request, token: 'Token')
      expect(subject.to_hash['Token']).to eq('Token')
    end

    it ':parameter1 maps to Parameter1' do
      subject.parameters = build(:magic_request, parameter1: 'Parameter1')
      expect(subject.to_hash['Parameter1']).to eq('Parameter1')
    end

    it ':parameter2 maps to Parameter2' do
      subject.parameters = build(:magic_request, parameter2: 'Parameter2')
      expect(subject.to_hash['Parameter2']).to eq('Parameter2')
    end

    it ':parameter3 maps to Parameter3' do
      subject.parameters = build(:magic_request, parameter3: 'Parameter3')
      expect(subject.to_hash['Parameter3']).to eq('Parameter3')
    end

    it ':parameter4 maps to Parameter4' do
      subject.parameters = build(:magic_request, parameter4: 'Parameter4')
      expect(subject.to_hash['Parameter4']).to eq('Parameter4')
    end

    it ':parameter5 maps to Parameter5' do
      subject.parameters = build(:magic_request, parameter5: 'Parameter5')
      expect(subject.to_hash['Parameter5']).to eq('Parameter5')
    end

    it ':parameter6 maps to Parameter6' do
      subject.parameters = build(:magic_request, parameter6: 'Parameter6')
      expect(subject.to_hash['Parameter6']).to eq('Parameter6')
    end

    it 'calls process_date on parameters' do
      subject.parameters = build(:populated_magic_request)
      expect(subject).to receive(:process_date).exactly(6).times
      subject.to_hash
    end
  end

  describe '#process_date' do
    context 'when given nil' do
      it { expect(subject.send(:process_date, nil)).to be_nil }
    end

    context 'when given a non-date string' do
      it do
        not_a_date = Faker::Name.name
        expect(subject.send(:process_date, not_a_date)).to eq(not_a_date)
      end
    end

    context 'when given a date string' do
      it 'returns an ISO8601 string' do
        date = '10/24/2013'
        expect(subject.send(:process_date, date)).to eq('2013-10-24')
      end
    end

    context 'when given a UTC date time string' do
      it 'returns an ISO8601 string' do
        now = DateTime.now.utc
        now_iso8601 = now.strftime('%Y-%m-%dT%H:%M:%S%:z')
        expect(subject.send(:process_date, now_iso8601)).to eq(now_iso8601)
      end
    end

    context 'when given a Date' do
      it 'returns an ISO8601 string' do
        today = Date.today
        today_iso8601 = Date.today.iso8601
        expect(subject.send(:process_date, today)).to eq(today_iso8601)
      end
    end

    context 'when given a UTC Time' do
      it 'returns an ISO8601 string' do
        now = Time.now.utc
        now_iso8601 = now.strftime('%Y-%m-%dT%H:%M:%S%:z')
        expect(subject.send(:process_date, now)).to eq(now_iso8601)
      end
    end

    context 'when given a UTC DateTime' do
      it 'returns an ISO8601 string' do
        now = DateTime.now.utc
        now_iso8601 = now.strftime('%Y-%m-%dT%H:%M:%S%:z')
        expect(subject.send(:process_date, now)).to eq(now_iso8601)
      end
    end

    context 'when using raw_dates option' do
      let!(:magic_request2) { build(:magic_request, raw_dates: true) }

      it 'returns the date that was supplied' do
        now = '03-29-2021 23:59:59.999'
        expect(subject.send(:process_date, now)).to eq(now)
      end
    end
  end
end
