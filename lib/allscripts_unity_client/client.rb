require 'nokogiri'

module AllscriptsUnityClient

  # Providers an interface to access Unity endpoints.
  #
  # Build using a dependency injection pattern. A Client instances takes an instance of
  # ClientDriver and delegates Unity endpoint methods to the ClientDriver.
  class Client
    attr_accessor :client_driver

    # Constructor.
    #
    # client_driver:: An instance of a ClientDriver. Currently only SoapClientDriver and JsonClientDriver
    # are supported.
    def initialize(client_driver)
      raise ArgumentError, 'client_driver can not be nil' if client_driver.nil?

      @client_driver = client_driver
    end

    # Access client's options. See ClientOptions.
    def options
      @client_driver.options
    end

    # Implement Unity's Magic endpoint
    #
    # parameters:: A Hash of Unity parameters. Takes this form:
    #
    #   {
    #     :action => ...,
    #     :userid => ...,
    #     :appname => ...,
    #     :patientid => ...,
    #     :token => ...,
    #     :parameter1 => ...,
    #     :parameter2 => ...,
    #     :parameter3 => ...,
    #     :parameter4 => ...,
    #     :parameter5 => ...,
    #     :parameter6 => ...,
    #     :data => ...
    #   }
    #
    # Returns the result of the Magic endpoint as a Hash.
    def magic(parameters = {})
      @client_driver.magic(parameters)
    end

    # Implement Unity's GetSecurityToken endpoint.
    #
    # Stores the results in @security_token.
    #
    # parameters:: A hash of Unity parameters for GetSecurityToken:
    #
    #   {
    #     :username => ...,
    #     :password => ...,
    #     :appname => ...
    #   }
    #
    # Returns the security token.
    def get_security_token!(parameters = {})
      @client_driver.get_security_token!(parameters)
    end

    # Implement Unity's RetireSecurityToken endpoint using Savon.
    #
    # parameters:: A hash of Unity parameters for RetireSecurityToken. If not given then defaults to
    # @security_token:
    #
    #   {
    #     :token => ...,
    #     :appname => ...
    #   }
    def retire_security_token!(parameters = {})
      @client_driver.retire_security_token!(parameters)
    end

    # Return true if a Unity security token has been fetched and saved.
    def security_token?
      @client_driver.security_token?
    end

    # Return the client type, either :json or :soap.
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

    def get_clinical_summary(userid, patientid, extra_med_data = false)
      magic_parameters = {
        action: 'GetClinicalSummary',
        userid: userid,
        patientid: patientid,
        parameter3: extra_med_data ? 'Y' : nil
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

    # GetEncounterList helper method.
    # @param [Object] userid
    # @param [Object] patientid
    # @param [String, nil] encounter_type encounter type to filter
    #   on. A value of `nil` filters nothing. Defaults to `nil`.
    # @param [Object] when_param
    # @param [Fixnum, nil] nostradamus how many days to look into the
    #   future. Defaults to `0`.
    # @param [Object] show_past_flag whether to show previous
    #   encounters. All truthy values aside from the string `"N"` are
    #   considered to be true (or `"Y"`) all other values are
    #   considered to be false (or `"N"`). Defaults to `true`.  
    # @param [Object] billing_provider_user_name filter by user
    #   name. Defaults to `nil`.
    # @param [Object] show_all
    # @return [Array<Hash>] the filtered encounter list.
    def get_encounter_list(
        userid,
        patientid,
        encounter_type = nil,
        when_param = nil,
        nostradamus = 0,
        show_past_flag = true,
        billing_provider_user_name = nil,
        show_all = false)
      magic_parameters = {
        action: 'GetEncounterList',
        userid: userid,
        patientid: patientid,
        parameter1: encounter_type,
        parameter2: when_param,
        parameter3: nostradamus,
        parameter4: show_past_flag && show_past_flag != 'N' ? 'Y' : 'N',
        parameter5: billing_provider_user_name,
        # According to the developer guide this parameter is no longer
        # used.
        parameter6: show_all ? 'all' : nil
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
      result = magic(magic_parameters)

      if transaction_id == 0 || transaction_id == '0'
        # When transaction_id is 0 all medications should be
        # returned and the result should always be an array.
        if !result.is_a?(Array) && !result.empty?
          result = [ result ]
        elsif result.empty?
          result = []
        end
      end

      result
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

    def get_patient_by_mrn(userid, mrn)
      magic_parameters = {
        action: 'GetPatientByMRN',
        userid: userid,
        parameter1: mrn
      }
      magic(magic_parameters)
    end

    def get_patient_cda
      raise NotImplementedError, 'GetPatientCDA magic action not implemented'
    end

    def get_patient_diagnosis(userid, patientid, encounter_date = nil, encounter_type = nil, encounter_date_range = nil, encounter_id = nil)
      magic_params = {
        action: 'GetPatientDiagnosis',
        userid: userid,
        patientid: patientid,
        parameter1: encounter_date,
        parameter2: encounter_type,
        parameter3: encounter_date_range,
        parameter4: encounter_id
      }

      results = magic(magic_params)

      if !results.is_a? Array
        if results.empty?
          results = []
        else
          results = [results]
        end
      end

      results
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
          xml.field('name' => 'transid', 'value' => rxxml[:transid]) unless rxxml[:transid]
          xml.field('name' => 'PharmID', 'value' => rxxml[:pharmid]) unless rxxml[:pharmid]
          xml.field('name' => 'DDI', 'value' => rxxml[:ddi]) unless rxxml[:ddi]
          xml.field('name' => 'GPPCCode', 'value' => rxxml[:gppccode]) unless rxxml[:gppccode]
          xml.field('name' => 'GPPCText', 'value' => rxxml[:gppctext]) unless rxxml[:gppctext]
          xml.field('name' => 'GPPCCustom', 'value' => rxxml[:gppccustom]) unless rxxml[:gppccustom]
          xml.field('name' => 'Sig', 'value' => rxxml[:sig]) unless rxxml[:sig]
          xml.field('name' => 'QuanPresc', 'value' => rxxml[:quanpresc]) unless rxxml[:quanpresc]
          xml.field('name' => 'Refills', 'value' => rxxml[:refills]) unless rxxml[:refills]
          xml.field('name' => 'DAW', 'value' => rxxml[:daw]) unless rxxml[:daw]
          xml.field('name' => 'DaysSupply', 'value' => rxxml[:dayssupply]) unless rxxml[:dayssupply]
          xml.field('name' => 'startdate', 'value' => utc_to_local(Date.parse(rxxml[:startdate].to_s))) unless rxxml[:startdate]
          xml.field('name' => 'historicalflag', 'value' => rxxml[:historicalflag]) unless rxxml[:historicalflag]
          xml.field('name' => 'rxaction', 'value' => rxxml[:rxaction]) unless rxxml[:rxaction]
          xml.field('name' => 'delivery', 'value' => rxxml[:delivery]) unless rxxml[:delivery]
          xml.field('name' => 'ignorepharmzero', 'value' => rxxml[:ignorepharmzero]) unless rxxml[:ignorepharmzero]
          xml.field('name' => 'orderedbyid', 'value' => rxxml[:orderedbyid]) unless rxxml[:orderedbyid]
          xml.field('name' => 'newqty', 'value' => rxxml[:newqty]) unless rxxml[:newqty]
          xml.field('name' => 'newrefills', 'value' => rxxml[:newrefills]) unless rxxml[:newrefills]
          xml.field('name' => 'comments', 'value' => rxxml[:comments]) unless rxxml[:comments]
          xml.field('name' => 'orderstatus', 'value' => rxxml[:order_status]) unless rxxml[:order_status]

          if rxxml[:problems]
            rxxml[:problems].each do |problem|
              xml.field('name' => 'Problem', 'value' => problem)
            end
          end
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

    def save_task_status(userid, transaction_id = nil, status = nil, delegate_id = nil, comment = nil, taskchanges = nil, patient_id = nil)
      if transaction_id.nil? && delegate_id.nil? && comment.nil?
        raise ArugmentError, 'transaction_id, delegate_id, and comment can not all be nil'
      end

      # Generate XML structure for rxxml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.taskchanges {
          xml.refills('value' => taskchanges[:refills]) unless taskchanges.nil? || taskchanges[:refills].nil?
          xml.days('value' => taskchanges[:days]) unless taskchanges.nil? || taskchanges[:days].nil?
          xml.qty('value' => taskchanges[:qty]) unless taskchanges.nil? || taskchanges[:qty].nil?
          xml.tasktype('value' => taskchanges[:tasktype]) unless taskchanges.nil? || taskchanges[:tasktype].nil?
          xml.delegated('value' => taskchanges[:delegated]) unless taskchanges.nil? || taskchanges[:delegated].nil?
          xml.taskstatus('value' => taskchanges[:taskstatus]) unless taskchanges.nil? || taskchanges[:taskstatus].nil?
          xml.removereason('value' => taskchanges[:removereason]) unless taskchanges.nil? || taskchanges[:removereason].nil?
          xml.denyreason('value' => taskchanges[:denyreason]) unless taskchanges.nil? || taskchanges[:denyreason].nil?
        }
      end

      magic_parameters = {
        action: 'SaveTaskStatus',
        userid: userid,
        patientid: patient_id,
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
