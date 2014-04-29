require 'spec_helper'

describe 'Client' do
  subject { FactoryGirl.build(:client) }

  describe '#initialize' do
    context 'when given nil for client_driver' do
      it { expect { FactoryGirl.build(:client, client_driver: nil) }.to raise_error(ArgumentError) }
    end
  end

  describe '#magic' do
    it 'calls magic on @client_driver' do
      subject.client_driver = double(magic: 'magic')
      subject.magic
      expect(subject.client_driver).to have_received(:magic)
    end
  end

  describe '#get_security_token!' do
    it 'calls get_security_token! on @client_driver' do
      subject.client_driver = double(get_security_token!: 'get_security_token!')
      subject.get_security_token!
      expect(subject.client_driver).to have_received(:get_security_token!)
    end
  end

  describe '#retire_security_token!' do
    it 'calls retire_security_token! on @client_driver' do
      subject.client_driver = double(retire_security_token!: 'retire_security_token!')
      subject.retire_security_token!
      expect(subject.client_driver).to have_received(:retire_security_token!)
    end
  end

  describe '#security_token?' do
    it 'calls security_token? on @client_driver' do
      subject.client_driver = double(security_token?: 'security_token?')
      subject.security_token?
      expect(subject.client_driver).to have_received(:security_token?)
    end
  end

  describe '#client_type' do
    it 'calls client_type on @client_driver' do
      subject.client_driver = double(client_type: 'client_type?')
      subject.client_type
      expect(subject.client_driver).to have_received(:client_type)
    end
  end

  describe '#commit_charges' do
    it { expect { subject.commit_charges }.to raise_error(NotImplementedError) }
  end

  describe '#echo'

  describe '#get_account' do
    it { expect { subject.get_account }.to raise_error(NotImplementedError) }
  end

  describe '#get_changed_patients'

  describe '#get_charge_info_by_username' do
    it { expect { subject.get_charge_info_by_username }.to raise_error(NotImplementedError) }
  end

  describe '#get_charges' do
    it { expect { subject.get_charges }.to raise_error(NotImplementedError) }
  end

  describe '#get_chart_item_details'
  describe '#get_clinical_summary'

  describe '#get_delegates' do
    it { expect { subject.get_delegates }.to raise_error(NotImplementedError) }
  end

  describe '#get_dictionary'

  describe '#get_dictionary_sets' do
    it { expect { subject.get_dictionary_sets }.to raise_error(NotImplementedError) }
  end

  describe '#get_doc_template' do
    it { expect { subject.get_doc_template }.to raise_error(NotImplementedError) }
  end

  describe '#get_document_by_accession' do
    it { expect { subject.get_document_by_accession }.to raise_error(NotImplementedError) }
  end

  describe '#get_document_image' do
    it { expect { subject.get_document_image }.to raise_error(NotImplementedError) }
  end

  describe '#get_documents' do
    it { expect { subject.get_documents }.to raise_error(NotImplementedError) }
  end

  describe '#get_document_type' do
    it { expect { subject.get_document_type }.to raise_error(NotImplementedError) }
  end

  describe '#get_dur' do
    it { expect { subject.get_dur }.to raise_error(NotImplementedError) }
  end

  describe '#get_encounter' do
    it { expect { subject.get_encounter }.to raise_error(NotImplementedError) }
  end

  describe '#get_encounter_date' do
    it { expect { subject.get_encounter_date }.to raise_error(NotImplementedError) }
  end

  describe '#get_encounter_list'

  describe '#get_hie_document' do
    it { expect { subject.get_hie_document }.to raise_error(NotImplementedError) }
  end

  describe '#get_last_patient' do
    it { expect { subject.get_last_patient }.to raise_error(NotImplementedError) }
  end

  describe '#get_list_of_dictionaries' do
    it { expect { subject.get_list_of_dictionaries }.to raise_error(NotImplementedError) }
  end

  describe '#get_medication_by_trans_id'

  describe '#get_order_history' do
    it { expect { subject.get_order_history }.to raise_error(NotImplementedError) }
  end

  describe '#get_organization_id' do
    it { expect { subject.get_organization_id }.to raise_error(NotImplementedError) }
  end

  describe '#get_packages' do
    it { expect { subject.get_packages }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient'
  describe '#get_patient_activity'

  describe '#get_patient_by_mrn' do
    it { expect { subject.get_patient_by_mrn }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_cda' do
    it { expect { subject.get_patient_cda }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_diagnosis' do
    it { expect { subject.get_patient_diagnosis }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_full' do
    it { expect { subject.get_patient_full }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_ids' do
    it { expect { subject.get_patient_ids }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_list' do
    it { expect { subject.get_patient_list }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_locations' do
    it { expect { subject.get_patient_locations }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_pharmacies' do
    it { expect { subject.get_patient_pharmacies }.to raise_error(NotImplementedError) }
  end

  describe '#get_patient_problems'
  describe '#get_patients_by_icd9'

  describe '#get_patient_sections' do
    it { expect { subject.get_patient_sections }.to raise_error(NotImplementedError) }
  end

  describe '#get_procedures' do
    it { expect { subject.get_procedures }.to raise_error(NotImplementedError) }
  end

  describe '#get_provider'
  describe '#get_providers'

  describe '#get_ref_providers_by_specialty' do
    it { expect { subject.get_ref_providers_by_specialty }.to raise_error(NotImplementedError) }
  end

  describe '#get_rounding_list_entries' do
    it { expect { subject.get_rounding_list_entries }.to raise_error(NotImplementedError) }
  end

  describe '#get_rounding_lists' do
    it { expect { subject.get_rounding_lists }.to raise_error(NotImplementedError) }
  end

  describe '#get_rx_favs' do
    it { expect { subject.get_rx_favs }.to raise_error(NotImplementedError) }
  end

  describe '#get_schedule' do
    it { expect { subject.get_schedule }.to raise_error(NotImplementedError) }
  end

  describe '#get_server_info'

  describe '#get_sigs' do
    it { expect { subject.get_sigs }.to raise_error(NotImplementedError) }
  end

  describe '#get_task'
  describe '#get_task_list'

  describe '#get_user_authentication' do
    it { expect { subject.get_user_authentication }.to raise_error(NotImplementedError) }
  end

  describe '#get_user_id' do
    it { expect { subject.get_user_id }.to raise_error(NotImplementedError) }
  end

  describe '#get_user_security' do
    it { expect { subject.get_user_security }.to raise_error(NotImplementedError) }
  end

  describe '#get_vaccine_manufacturers' do
    it { expect { subject.get_vaccine_manufacturers }.to raise_error(NotImplementedError) }
  end

  describe '#get_vitals' do
    it { expect { subject.get_vitals }.to raise_error(NotImplementedError) }
  end

  describe '#make_task' do
    it { expect { subject.make_task }.to raise_error(NotImplementedError) }
  end

  describe '#save_admin_task' do
    it { expect { subject.save_admin_task }.to raise_error(NotImplementedError) }
  end

  describe '#save_allergy' do
    it { expect { subject.save_allergy }.to raise_error(NotImplementedError) }
  end

  describe '#save_ced' do
    it { expect { subject.save_ced }.to raise_error(NotImplementedError) }
  end

  describe '#save_charge' do
    it { expect { subject.save_charge }.to raise_error(NotImplementedError) }
  end

  describe '#save_chart_view_audit' do
    it { expect { subject.save_chart_view_audit }.to raise_error(NotImplementedError) }
  end

  describe '#save_diagnosis' do
    it { expect { subject.save_diagnosis }.to raise_error(NotImplementedError) }
  end

  describe '#save_document_image' do
    it { expect { subject.save_document_image }.to raise_error(NotImplementedError) }
  end

  describe '#save_er_note' do
    it { expect { subject.save_er_note }.to raise_error(NotImplementedError) }
  end

  describe '#save_hie_document' do
    it { expect { subject.save_hie_document }.to raise_error(NotImplementedError) }
  end

  describe '#save_history' do
    it { expect { subject.save_history }.to raise_error(NotImplementedError) }
  end

  describe '#save_immunization' do
    it { expect { subject.save_immunization }.to raise_error(NotImplementedError) }
  end

  describe '#save_note' do
    it { expect { subject.save_note }.to raise_error(NotImplementedError) }
  end

  describe '#save_patient' do
    it { expect { subject.save_patient }.to raise_error(NotImplementedError) }
  end

  describe '#save_patient_location' do
    it { expect { subject.save_patient_location }.to raise_error(NotImplementedError) }
  end

  describe '#save_problem' do
    it { expect { subject.save_problem }.to raise_error(NotImplementedError) }
  end

  describe '#save_problems_data' do
    it { expect { subject.save_problems_data }.to raise_error(NotImplementedError) }
  end

  describe '#save_ref_provider' do
    it { expect { subject.save_ref_provider }.to raise_error(NotImplementedError) }
  end

  describe '#save_result' do
    it { expect { subject.save_result }.to raise_error(NotImplementedError) }
  end

  describe '#save_rx'

  describe '#save_simple_encounter' do
    it { expect { subject.save_simple_encounter }.to raise_error(NotImplementedError) }
  end

  describe '#save_simple_rx' do
    it { expect { subject.save_simple_rx }.to raise_error(NotImplementedError) }
  end

  describe '#save_specialist' do
    it { expect { subject.save_specialist }.to raise_error(NotImplementedError) }
  end

  describe '#save_task'
  describe '#save_task_status'

  describe '#save_tiff' do
    it { expect { subject.save_tiff }.to raise_error(NotImplementedError) }
  end

  describe '#save_unstructured_document' do
    it { expect { subject.save_unstructured_document }.to raise_error(NotImplementedError) }
  end

  describe '#save_v10_doc_signature' do
    it { expect { subject.save_v10_doc_signature }.to raise_error(NotImplementedError) }
  end

  describe '#save_v11_note' do
    it { expect { subject.save_v11_note }.to raise_error(NotImplementedError) }
  end

  describe '#save_vitals' do
    it { expect { subject.save_vitals }.to raise_error(NotImplementedError) }
  end

  describe '#save_vitals_data' do
    it { expect { subject.save_vitals_data }.to raise_error(NotImplementedError) }
  end

  describe '#search_charge_codes' do
    it { expect { subject.search_charge_codes }.to raise_error(NotImplementedError) }
  end

  describe '#search_diagnosis_codes' do
    it { expect { subject.search_diagnosis_codes }.to raise_error(NotImplementedError) }
  end

  describe '#search_meds'
  describe '#search_patients'

  describe '#search_patients_rxhub5' do
    it { expect { subject.search_patients_rxhub5 }.to raise_error(NotImplementedError) }
  end

  describe '#search_pharmacies'

  describe '#search_problem_codes' do
    it { expect { subject.search_problem_codes }.to raise_error(NotImplementedError) }
  end

  describe '#update_encounter' do
    it { expect { subject.update_encounter }.to raise_error(NotImplementedError) }
  end

  describe '#update_order' do
    it { expect { subject.update_order }.to raise_error(NotImplementedError) }
  end

  describe '#update_referral_order_status' do
    it { expect { subject.update_referral_order_status }.to raise_error(NotImplementedError) }
  end

  describe '#nokogiri_to_string' do
    context 'when given a Nokogiri::XML::Builder' do
      it 'returns an XML string' do
        builder = Nokogiri::XML::Builder.new { |xml| xml.field 'test' }
        expect(subject.send(:nokogiri_to_string, builder)).to eq('<field>test</field>')
      end
    end
  end
end