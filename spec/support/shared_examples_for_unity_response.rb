shared_examples 'a unity response' do
  let(:attributes_hash) do
    {
      :"@attribute1" => {
        :"@nested_attribute1" => true,
        :normal_key => true
      },
      :"@attribute2" => true,
      :normal_key_2 => true,
      :array_of_attributes => [
        { :"@attribute" => true, :value => { :"@attribute" => true, :value => true } },
        { :"@attribute" => true, :value => true },
        { :"@attribute" => true, :value => true }
      ]
    }
  end

  let(:stripped_attributes_hash) do
    {
      :normal_key_2 => true,
      :array_of_attributes => [
        { :value => { :value => true } },
        { :value => true },
        { :value => true }
      ]
    }
  end

  let(:date_hash) do
    {
      :date_string => "2013-02-15",
      :date_string2 => {
        :value => "2013-02-15"
      },
      :date_array => [
        "2013-02-15",
        "2013-02-15",
        "2013-02-15"
      ]
    }
  end

  let(:converted_date_hash) do
    {
      :date_string => Date.parse("2013-02-15"),
      :date_string2 => {
        :value => Date.parse("2013-02-15")
      },
      :date_array => [
        Date.parse("2013-02-15"),
        Date.parse("2013-02-15"),
        Date.parse("2013-02-15")
      ]
    }
  end

  describe '#strip_attributes' do
    context 'when given nil' do
      it { expect(unity_response.send(:strip_attributes, nil)).to be_nil }
    end

    it 'recursively strips attribute keys off hashes' do
      expect(unity_response.send(:strip_attributes, attributes_hash)).to eq(stripped_attributes_hash)
    end
  end

  describe '#convert_dates_to_utc' do
    context 'when given nil' do
      it { expect(unity_response.send(:convert_dates_to_utc, nil)).to be_nil }
    end

    it 'recursively converts date strings' do
      expect(unity_response.send(:convert_dates_to_utc, date_hash)).to eq(converted_date_hash)
    end
  end
end