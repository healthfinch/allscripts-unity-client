shared_examples 'a unity request' do
  let(:magic_request) { FactoryGirl.build(:magic_request) }

  describe '#to_hash' do
    it ':action maps to Action' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :action => 'Action')
      expect(unity_request.to_hash['Action']).to eq('Action')
    end

    it ':appname maps to Appname' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :appname => 'Appname')
      expect(unity_request.to_hash['Appname']).to eq('Appname')
    end

    it ':patientid maps to PatientID' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :patientid => 'PatientID')
      expect(unity_request.to_hash['PatientID']).to eq('PatientID')
    end

    it ':token maps to Token' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :token => 'Token')
      expect(unity_request.to_hash['Token']).to eq('Token')
    end

    it ':parameter1 maps to Parameter1' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :parameter1 => 'Parameter1')
      expect(unity_request.to_hash['Parameter1']).to eq('Parameter1')
    end

    it ':parameter2 maps to Parameter2' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :parameter2 => 'Parameter2')
      expect(unity_request.to_hash['Parameter2']).to eq('Parameter2')
    end

    it ':parameter3 maps to Parameter3' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :parameter3 => 'Parameter3')
      expect(unity_request.to_hash['Parameter3']).to eq('Parameter3')
    end

    it ':parameter4 maps to Parameter4' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :parameter4 => 'Parameter4')
      expect(unity_request.to_hash['Parameter4']).to eq('Parameter4')
    end

    it ':parameter5 maps to Parameter5' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :parameter5 => 'Parameter5')
      expect(unity_request.to_hash['Parameter5']).to eq('Parameter5')
    end

    it ':parameter6 maps to Parameter6' do
      unity_request.parameters = FactoryGirl.build(:magic_request, :parameter6 => 'Parameter6')
      expect(unity_request.to_hash['Parameter6']).to eq('Parameter6')
    end

    it 'calls process_date on parameters' do
      unity_request = FactoryGirl.build(:unity_request, :parameters => FactoryGirl.build(:populated_magic_request))
      allow(unity_request).to receive(:process_date)
      unity_request.to_hash
      expect(unity_request).to have_received(:process_date).exactly(6).times
    end
  end

  describe '#process_date' do
    context 'when given nil' do
      it { expect(unity_request.send(:process_date, nil)).to be_nil }
    end

    context 'when given a non-date string' do
      it do
        not_a_date = Faker::Name.name
        expect(unity_request.send(:process_date, not_a_date)).to eq(not_a_date)
      end
    end

    context 'when given a date string' do
      it do
        date = "2013-10-24"
        expect(unity_request.send(:process_date, date)).to be_instance_of(Date)
      end
    end

    context 'when given a Date' do
      it { expect(unity_request.send(:process_date, Date.today)).to be_instance_of(Date) }
    end

    context 'when given a Time' do
      it { expect(unity_request.send(:process_date, Time.now)).to be_instance_of(Time) }
    end

    context 'when given a DateTime' do
      it { expect(unity_request.send(:process_date, DateTime.now)).to be_instance_of(DateTime) }
    end
  end
end