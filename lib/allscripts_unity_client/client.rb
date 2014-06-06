require 'nokogiri'

module AllscriptsUnityClient
  class Client
    attr_accessor :client_driver

    def initialize(client_driver)
      raise ArgumentError, 'client_driver can not be nil' if client_driver.nil?

      @client_driver = client_driver
    end

    def options
      @client_driver.options
    end

    def magic(parameters = {})
      @client_driver.magic(parameters)
    end

    def get_security_token!(parameters = {})
      @client_driver.get_security_token!(parameters)
    end

    def retire_security_token!(parameters = {})
      @client_driver.retire_security_token!(parameters)
    end

    def security_token?
      @client_driver.security_token?
    end

    def client_type
      @client_driver.client_type
    end

    def commit_charges
      raise NotImplementedError, 'CommitCharges magic action not implemented'
    end

    def echo(echo_text)
      magic_parameters = {
        action: 'Echo',
        userid: echo_text,
        appname: echo_text,
        patientid: echo_text,
        parameter1: echo_text,
        parameter2: echo_text,
        parameter3: echo_text,
        parameter4: echo_text,
        parameter5: echo_text,
        parameter6: echo_text
      }
      response = magic(magic_parameters)
      response[:userid]
    end

    def get_account
      raise NotImplementedError, 'GetAccount magic action not implemented'
    end

    def get_changed_patients(since = nil)
      magic_parameters = {
        action: 'GetChangedPatients',
        parameter1: since
      }
      magic(magic_parameters)
    end

    def get_charge_info_by_username
      raise NotImplementedError, 'GetChargeInfoByUsername magic action not implemented'
    end

    def get_charges
      raise NotImplementedError, 'GetCharges magic action not implemented'
    end

    def get_chart_item_details(userid, patientid, section)
      magic_parameters = {
        action: 'GetChartItemDetails',
        userid: userid,
        patientid: patientid,
        parameter1: section
      }
      magic(magic_parameters)
    end

    def get_clinical_summary(userid, patientid)
      magic_parameters = {
        action: 'GetClinicalSummary',
        userid: userid,
        patientid: patientid
      }
      response = magic(magic_parameters)

      unless response.is_a?(Array)
        response = [ response ]
      end

      response
    end

    def get_delegates
      raise NotImplementedError, 'GetDelegates magic action not implemented'
    end

    def get_dictionary(dictionary_name, userid = nil, site = nil)
      magic_parameters = {
        action: 'GetDictionary',
        userid: userid,
        parameter1: dictionary_name,
        parameter2: site
      }
      response = magic(magic_parameters)

      unless response.is_a?(Array)
        response = [ response ]
      end

      response
    end

    def get_dictionary_sets
      raise NotImplementedError, 'GetDictionarySets magic action not implemented'
    end

    def get_doc_template
      raise NotImplementedError, 'GetDocTemplate magic action not implemented'
    end

    def get_document_by_accession
      raise NotImplementedError, 'GetDocumentByAccession magic action not implemented'
    end

    def get_document_image
      raise NotImplementedError, 'GetDocumentImage magic action not implemented'
    end

    def get_documents
      raise NotImplementedError, 'GetDocuments magic action not implemented'
    end

    def get_document_type
      raise NotImplementedError, 'GetDocumentType magic action not implemented'
    end

    def get_dur
      raise NotImplementedError, 'GetDUR magic action not implemented'
    end

    def get_encounter
      raise NotImplementedError, 'GetEncounter magic action not implemented'
    end

    def get_encounter_date
      raise NotImplementedError, 'GetEncounterDate magic action not implemented'
    end

    def get_encounter_list(userid, patientid, encounter_type, when_param = nil, nostradamus = nil, show_past_flag = nil, billing_provider_user_name = nil)
      magic_parameters = {
        action: 'GetEncounterList',
        userid: userid,
        patientid: patientid,
        parameter1: encounter_type,
        parameter2: when_param,
        parameter3: nostradamus,
        parameter4: show_past_flag,
        parameter5: billing_provider_user_name
      }
      response = magic(magic_parameters)

      unless response.is_a?(Array)
        response = [ response ]
      end

      # Remove nil encounters
      response.delete_if do |value|
        value[:id] == '0' && value[:patientid] == '0'
      end
    end

    def get_hie_document
      raise NotImplementedError, 'GetHIEDocument magic action not implemented'
    end

    def get_last_patient
      raise NotImplementedError, 'GetLastPatient magic action not implemented'
    end

    def get_list_of_dictionaries
      raise NotImplementedError, 'GetListOfDictionaries magic action not implemented'
    end

    def get_medication_by_trans_id(userid, patientid, transaction_id)
      magic_parameters = {
        action: 'GetMedicationByTransID',
        userid: userid,
        patientid: patientid,
        parameter1: transaction_id
      }
      magic(magic_parameters)
    end

    def get_medication_info(userid, ddid, patientid = nil)
      magic_parameters = {
        action: 'GetMedicationInfo',
        userid: userid,
        patientid: patientid,
        parameter1: ddid
      }
      magic(magic_parameters)
    end

    def get_order_history
      raise NotImplementedError, 'GetOrderHistory magic action not implemented'
    end

    def get_organization_id
      raise NotImplementedError, 'GetOrganizationID magic action not implemented'
    end

    def get_packages
      raise NotImplementedError, 'GetPackages magic action not implemented'
    end

    def get_patient(userid, patientid, includepix = nil)
      magic_parameters = {
        action: 'GetPatient',
        userid: userid,
        patientid: patientid,
        parameter1: includepix
      }
      magic(magic_parameters)
    end

    def get_patient_activity(userid, patientid)
      magic_parameters = {
        action: 'GetPatientActivity',
        userid: userid,
        patientid: patientid
      }
      magic(magic_parameters)
    end

    def get_patient_by_mrn
      raise NotImplementedError, 'GetPatientByMRN magic action not implemented'
    end

    def get_patient_cda
      raise NotImplementedError, 'GetPatientCDA magic action not implemented'
    end

    def get_patient_diagnosis
      raise NotImplementedError, 'GetPatientDiagnosis magic action not implemented'
    end

    def get_patient_full
      raise NotImplementedError, 'GetPatientFull magic action not implemented'
    end

    def get_patient_ids
      raise NotImplementedError, 'GetPatientIDs magic action not implemented'
    end

    def get_patient_list
      raise NotImplementedError, 'GetPatientList magic action not implemented'
    end

    def get_patient_locations
      raise NotImplementedError, 'GetPatientLocations magic action not implemented'
    end

    def get_patient_pharmacies
      raise NotImplementedError, 'GetPatientPharmacies magic action not implemented'
    end

    def get_patient_problems(patientid, show_by_encounter_flag = nil, assessed = nil, encounter_id = nil, medcin_id = nil)
      magic_parameters = {
        action: 'GetPatientProblems',
        patientid: patientid,
        parameter1: show_by_encounter_flag,
        parameter2: assessed,
        parameter3: encounter_id,
        parameter4: medcin_id
      }
      response = magic(magic_parameters)

      unless response.is_a?(Array)
        response = [ response ]
      end

      response
    end

    def get_patients_by_icd9(icd9, start = nil, end_param = nil)
      magic_parameters = {
        action: 'GetPatientsByICD9',
        parameter1: icd9,
        parameter2: start,
        parameter3: end_param
      }
      magic(magic_parameters)
    end

    def get_patient_sections
      raise NotImplementedError, 'GetPatientSections magic action not implemented'
    end

    def get_procedures
      raise NotImplementedError, 'GetProcedures magic action not implemented'
    end

    def get_provider(provider_id = nil, user_name = nil)
      if provider_id.nil? && user_name.nil?
        raise ArgumentError, 'provider_id or user_name must be given'
      end

      magic_parameters = {
        action: 'GetProvider',
        parameter1: provider_id,
        parameter2: user_name
      }
      magic(magic_parameters)
    end

    def get_providers(security_filter = nil, name_filter = nil)
      magic_parameters = {
        action: 'GetProviders',
        parameter1: security_filter,
        parameter2: name_filter
      }
      response = magic(magic_parameters)

      unless response.is_a?(Array)
        response = [ response ]
      end

      response
    end

    def get_ref_providers_by_specialty
      raise NotImplementedError, 'GetRefProvidersBySpecialty magic action not implemented'
    end

    def get_rounding_list_entries
      raise NotImplementedError, 'GetRoundingListEntries magic action not implemented'
    end

    def get_rounding_lists
      raise NotImplementedError, 'GetRoundingLists magic action not implemented'
    end

    def get_rx_favs
      raise NotImplementedError, 'GetRXFavs magic action not implemented'
    end

    def get_schedule
      raise NotImplementedError, 'GetSchedule magic action not implemented'
    end

    def get_server_info
      magic_parameters = {
        action: 'GetServerInfo'
      }
      magic(magic_parameters)
    end

    def get_sigs
      raise NotImplementedError, 'GetSigs magic action not implemented'
    end

    def get_task(userid, transaction_id)
      magic_parameters = {
        action: 'GetTask',
        userid: userid,
        parameter1: transaction_id
      }
      magic(magic_parameters)
    end

    def get_task_list(userid = nil, since = nil, delegated = nil)
      magic_parameters = {
        action: 'GetTaskList',
        userid: userid,
        parameter1: since,
        parameter4: delegated
      }
      response = magic(magic_parameters)

      unless response.is_a?(Array)
        response = [ response ]
      end

      response
    end

    def get_user_authentication
      raise NotImplementedError, 'GetUserAuthentication magic action not implemented'
    end

    def get_user_id
      raise NotImplementedError, 'GetUserID magic action not implemented'
    end

    def get_user_security
      raise NotImplementedError, 'GetUserSecurity magic action not implemented'
    end

    def get_vaccine_manufacturers
      raise NotImplementedError, 'GetVaccineManufacturers magic action not implemented'
    end

    def get_vitals
      raise NotImplementedError, 'GetVitals magic action not implemented'
    end

    def last_logs
      magic_parameters = {
        action: 'LastLogs'
      }
      magic(magic_parameters)
    end

    def make_task
      raise NotImplementedError, 'MakeTask magic action not implemented'
    end

    def save_admin_task
      raise NotImplementedError, 'SaveAdminTask magic action not implemented'
    end

    def save_allergy
      raise NotImplementedError, 'SaveAllergy magic action not implemented'
    end

    def save_ced
      raise NotImplementedError, 'SaveCED magic action not implemented'
    end

    def save_charge
      raise NotImplementedError, 'SaveCharge magic action not implemented'
    end

    def save_chart_view_audit
      raise NotImplementedError, 'SaveChartViewAudit magic action not implemented'
    end

    def save_diagnosis
      raise NotImplementedError, 'SaveDiagnosis magic action not implemented'
    end

    def save_document_image
      raise NotImplementedError, 'SaveDocumentImage magic action not implemented'
    end

    def save_er_note
      raise NotImplementedError, 'SaveERNote magic action not implemented'
    end

    def save_hie_document
      raise NotImplementedError, 'SaveHIEDocument magic action not implemented'
    end

    def save_history
      raise NotImplementedError, 'SaveHistory magic action not implemented'
    end

    def save_immunization
      raise NotImplementedError, 'SaveImmunization magic action not implemented'
    end

    def save_note
      raise NotImplementedError, 'SaveNote magic action not implemented'
    end

    def save_patient
      raise NotImplementedError, 'SavePatient magic action not implemented'
    end

    def save_patient_location
      raise NotImplementedError, 'SavePatientLocation magic action not implemented'
    end

    def save_problem
      raise NotImplementedError, 'SaveProblem magic action not implemented'
    end

    def save_problems_data
      raise NotImplementedError, 'SaveProblemsData magic action not implemented'
    end

    def save_ref_provider
      raise NotImplementedError, 'SaveRefProvider magic action not implemented'
    end

    def save_result
      raise NotImplementedError, 'SaveResult magic action not implemented'
    end

    def save_rx(userid, patientid, rxxml)
      # Generate XML structure for rxxml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.saverx {
          xml.field('name' => 'transid', 'value' => rxxml[:transid]) unless rxxml[:transid].nil?
          xml.field('name' => 'PharmID', 'value' => rxxml[:pharmid]) unless rxxml[:pharmid].nil?
          xml.field('name' => 'DDI', 'value' => rxxml[:ddi]) unless rxxml[:ddi].nil?
          xml.field('name' => 'GPPCCode', 'value' => rxxml[:gppccode]) unless rxxml[:gppccode].nil?
          xml.field('name' => 'GPPCText', 'value' => rxxml[:gppctext]) unless rxxml[:gppctext].nil?
          xml.field('name' => 'GPPCCustom', 'value' => rxxml[:gppccustom]) unless rxxml[:gppccustom].nil?
          xml.field('name' => 'Sig', 'value' => rxxml[:sig]) unless rxxml[:sig].nil?
          xml.field('name' => 'QuanPresc', 'value' => rxxml[:quanpresc]) unless rxxml[:quanpresc].nil?
          xml.field('name' => 'Refills', 'value' => rxxml[:refills]) unless rxxml[:refills].nil?
          xml.field('name' => 'DAW', 'value' => rxxml[:daw]) unless rxxml[:daw].nil?
          xml.field('name' => 'DaysSupply', 'value' => rxxml[:dayssupply]) unless rxxml[:dayssupply].nil?
          xml.field('name' => 'startdate', 'value' => utc_to_local(Date.parse(rxxml[:startdate].to_s))) unless rxxml[:startdate].nil?
          xml.field('name' => 'historicalflag', 'value' => rxxml[:historicalflag]) unless rxxml[:historicalflag].nil?
          xml.field('name' => 'rxaction', 'value' => rxxml[:rxaction]) unless rxxml[:rxaction].nil?
          xml.field('name' => 'delivery', 'value' => rxxml[:delivery]) unless rxxml[:delivery].nil?
          xml.field('name' => 'ignorepharmzero', 'value' => rxxml[:ignorepharmzero]) unless rxxml[:ignorepharmzero].nil?
          xml.field('name' => 'orderedbyid', 'value' => rxxml[:orderedbyid]) unless rxxml[:orderedbyid].nil?
          xml.field('name' => 'newqty', 'value' => rxxml[:newqty]) unless rxxml[:newqty].nil?
          xml.field('name' => 'newrefills', 'value' => rxxml[:newrefills]) unless rxxml[:newrefills].nil?
          xml.field('name' => 'comments', 'value' => rxxml[:comments]) unless rxxml[:comments].nil?
        }
      end

      magic_parameters = {
        action: 'SaveRX',
        userid: userid,
        patientid: patientid,
        parameter1: nokogiri_to_string(builder)
      }
      magic(magic_parameters)
    end

    def save_simple_encounter
      raise NotImplementedError, 'SaveSimpleEncounter magic action not implemented'
    end

    def save_simple_rx
      raise NotImplementedError, 'SaveSimpleRX magic action not implemented'
    end

    def save_specialist
      raise NotImplementedError, 'SaveSpecialist magic action not implemented'
    end

    def save_task(userid, patientid, task_type = nil, target_user = nil, work_object_id = nil, comments = nil)
      if task_type.nil? && target_user.nil? && work_object_id.nil? && comments.nil?
        raise ArugmentError, 'task_type, target_user, work_object_id, and comments can not all be nil'
      end

      magic_parameters = {
        action: 'SaveTask',
        userid: userid,
        patientid: patientid,
        parameter1: task_type,
        parameter2: target_user,
        parameter3: work_object_id,
        parameter4: comments
      }
      magic(magic_parameters)
    end

    def save_task_status(userid, transaction_id = nil, status = nil, delegate_id = nil, comment = nil, taskchanges = nil)
      if transaction_id.nil? && param.nil? && delegate_id.nil? && comment.nil?
        raise ArugmentError, 'task_type, target_user, work_object_id, and comments can not all be nil'
      end

      # Generate XML structure for rxxml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.taskchanges {
          xml.refills('value' => taskchanges[:refills]) unless taskchanges.nil? || taskchanges[:refills].nil?
          xml.days('value' => taskchanges[:days]) unless taskchanges.nil? || taskchanges[:days].nil?
          xml.qty('value' => taskchanges[:qty]) unless taskchanges.nil? || taskchanges[:qty].nil?
          xml.tasktype('value' => taskchanges[:tasktype]) unless taskchanges.nil? || taskchanges[:tasktype].nil?
          xml.delegated('value' => taskchanges[:delegated]) unless taskchanges.nil? || taskchanges[:delegated].nil?
        }
      end

      magic_parameters = {
        action: 'SaveTaskStatus',
        userid: userid,
        parameter1: transaction_id,
        parameter2: status,
        parameter3: delegate_id,
        parameter4: comment,
        parameter6: nokogiri_to_string(builder)
      }
      magic(magic_parameters)
    end

    def save_tiff
      raise NotImplementedError, 'SaveTiff magic action not implemented'
    end

    def save_unstructured_document
      raise NotImplementedError, 'SaveUnstructuredDocument magic action not implemented'
    end

    def save_v10_doc_signature
      raise NotImplementedError, 'SaveV10DocSignature magic action not implemented'
    end

    def save_v11_note
      raise NotImplementedError, 'SaveV11Note magic action not implemented'
    end

    def save_vitals
      raise NotImplementedError, 'SaveVitals magic action not implemented'
    end

    def save_vitals_data
      raise NotImplementedError, 'SaveVitalsData magic action not implemented'
    end

    def search_charge_codes
      raise NotImplementedError, 'SearchChargeCodes magic action not implemented'
    end

    def search_diagnosis_codes
      raise NotImplementedError, 'SearchDiagnosisCodes magic action not implemented'
    end

    def search_meds(userid, patientid, search = nil)
      magic_parameters = {
        action: 'SearchMeds',
        userid: userid,
        patientid: patientid,
        parameter1: search
      }

      response = magic(magic_parameters)

      unless response.is_a?(Array)
        response = [ response ]
      end

      response
    end

    def search_patients(search)
      magic_parameters = {
        action: 'SearchPatients',
        parameter1: search
      }
      magic(magic_parameters)
    end

    def search_patients_rxhub5
      raise NotImplementedError, 'SearchPatientsRXHub5 magic action not implemented'
    end

    def search_pharmacies(search)
      magic_parameters = {
        action: 'SearchPharmacies',
        parameter1: search
      }
      magic(magic_parameters)
    end

    def search_problem_codes
      raise NotImplementedError, 'SearchProblemCodes magic action not implemented'
    end

    def update_encounter
      raise NotImplementedError, 'UpdateEncounter magic action not implemented'
    end

    def update_order
      raise NotImplementedError, 'UpdateOrder magic action not implemented'
    end

    def update_referral_order_status
      raise NotImplementedError, 'UpdateReferralOrderStatus magic action not implemented'
    end

    private

    def nokogiri_to_string(builder)
      builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
    end
  end
end