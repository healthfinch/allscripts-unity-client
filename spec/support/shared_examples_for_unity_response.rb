shared_examples 'a unity response' do
  let(:attributes_hash) { FixtureLoader.load_yaml('attributes_hash.yml') }
  let(:no_attributes_hash) { FixtureLoader.load_yaml('no_attributes_hash.yml') }
  let(:date_string_hash) { FixtureLoader.load_yaml('date_string_hash.yml') }
  let(:date_hash) { FixtureLoader.load_yaml('date_hash.yml') }

  describe '#strip_attributes' do
    context 'when given nil' do
      it { expect(subject.send(:strip_attributes, nil)).to be_nil }
    end

    it 'recursively strips attribute keys off hashes' do
      expect(subject.send(:strip_attributes, attributes_hash)).to eq(no_attributes_hash)
    end
  end

  describe '#convert_dates_to_utc' do
    context 'when given nil' do
      it { expect(subject.send(:convert_dates_to_utc, nil)).to be_nil }
    end

    it 'recursively converts date strings' do
      expect(subject.send(:convert_dates_to_utc, date_string_hash)).to eq(date_hash)
    end
  end
end