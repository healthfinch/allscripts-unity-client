module AllscriptsUnityClient
  class BaseClient
    attr_accessor :username, :password, :appname, :base_unity_url, :proxy_url, :security_token

    def initialize(base_unity_url, username, password, appname, proxy = nil, timezone = nil)
      @base_unity_url = base_unity_url.gsub /\/$/, ""
      @username = username
      @password = password
      @appname = appname
      @proxy = proxy

      unless timezone.nil?
        @timezone = TZInfo::Timezone.get(timezone)
      else
        @timezone = TZInfo::Timezone.get("UTC")
      end

      setup!
    end

    # Stub method that needs to be implemented by subclasses
    def setup!
      raise NotImplementedError, "create_client not implemented"
    end

    # Stub method that needs to be implemented by subclasses
    def magic(parameters = {})
      raise NotImplementedError, "Magic operation not implemented"
    end

    # Stub method that needs to be implemented by subclasses
    def get_security_token!(parameters = {})
      raise NotImplementedError, "GetSecurityToken operation not implemented"
    end

    # Stub method that needs to be implemented by subclasses
    def retire_security_token!(parameters = {})
      raise NotImplementedError, "RetireSecurityToken operation not implemented"
    end

    def security_token?
      return security_token.nil?
    end

    def commit_charges
      raise NotImplementedError, "CommitCharges magic action not implemented"
    end

    def echo(echo_text)
      magic_parameters = {
        :action => "Echo",
        :userid => echo_text,
        :appname => echo_text,
        :patientid => echo_text,
        :parameter1 => echo_text,
        :parameter2 => echo_text,
        :parameter3 => echo_text,
        :parameter4 => echo_text,
        :parameter5 => echo_text,
        :parameter6 => echo_text
      }
      response = magic(magic_parameters)
      response[:userid]
    end

    def get_account
      raise NotImplementedError, "GetAccount magic action not implemented"
    end

    def get_changed_patients(since = nil)
      magic_parameters = {
        :action => "GetChangedPatients",
        :parameter1 => since
      }
      magic(magic_parameters)
    end

    def get_charge_info_by_username
      raise NotImplementedError, "GetChargeInfoByUsername magic action not implemented"
    end

    def get_charges
      raise NotImplementedError, "GetCharges magic action not implemented"
    end

    def get_chart_item_details(userid, patientid, section)
      magic_parameters = {
        :action => "GetChartItemDetails",
        :userid => userid,
        :patientid => patientid,
        :parameter1 => section
      }
      magic(magic_parameters)
    end

    def get_clinical_summary(userid, patientid)
      magic_parameters = {
        :action => "GetClinicalSummary",
        :userid => userid,
        :patientid => patientid
      }
      magic(magic_parameters)
    end

    def get_delegates
      raise NotImplementedError, "GetDelegates magic action not implemented"
    end

    def get_dictionary(dictionary_name, userid = nil, site = nil)
      magic_parameters = {
        :action => "GetDictionary",
        :userid => userid,
        :parameter1 => dictionary_name,
        :parameter2 => site
      }
      magic(magic_parameters)
    end

    def get_dictionary_sets
      raise NotImplementedError, "GetDictionarySets magic action not implemented"
    end

    def get_doc_template
      raise NotImplementedError, "GetDocTemplate magic action not implemented"
    end

    def get_document_by_accession
      raise NotImplementedError, "GetDocumentByAccession magic action not implemented"
    end

    def get_document_image
      raise NotImplementedError, "GetDocumentImage magic action not implemented"
    end

    def get_documents
      raise NotImplementedError, "GetDocuments magic action not implemented"
    end

    def get_document_type
      raise NotImplementedError, "GetDocumentType magic action not implemented"
    end

    def get_dur
      raise NotImplementedError, "GetDUR magic action not implemented"
    end

    def get_encounter
      raise NotImplementedError, "GetEncounter magic action not implemented"
    end

    def get_encounter_date
      raise NotImplementedError, "GetEncounterDate magic action not implemented"
    end

    def get_encounter_list(userid, patientid, encounter_type, when_param = nil, nostradamus = nil, show_past_flag = nil, billing_provider_user_name = nil)
      magic_parameters = {
        :action => "GetEncounterList",
        :userid => userid,
        :patientid => patientid,
        :parameter1 => encounter_type,
        :parameter2 => when_param,
        :parameter3 => nostradamus,
        :parameter4 => show_past_flag,
        :parameter5 => billing_provider_user_name
      }
      response = magic(magic_parameters)

      # Remove nil encounters
      response.delete_if do |value|
        value[:id] == "0" && value[:patientid] == "0"
      end
    end

    def get_hie_document
      raise NotImplementedError, "GetHIEDocument magic action not implemented"
    end

    def get_last_patient
      raise NotImplementedError, "GetLastPatient magic action not implemented"
    end

    def get_list_of_dictionaries
      raise NotImplementedError, "GetListOfDictionaries magic action not implemented"
    end

    def get_medication_by_trans_id(userid, patientid, transaction_id)
      magic_parameters = {
        :action => "GetMedicationByTransID",
        :userid => userid,
        :patientid => patientid,
        :parameter1 => transaction_id
      }
      magic(magic_parameters)
    end

    def get_order_history
      raise NotImplementedError, "GetOrderHistory magic action not implemented"
    end

    def get_organization_id
      raise NotImplementedError, "GetOrganizationID magic action not implemented"
    end

    def get_packages
      raise NotImplementedError, "GetPackages magic action not implemented"
    end

    def get_patient(userid, patientid, includepix = nil)
      magic_parameters = {
        :action => "GetPatient",
        :userid => userid,
        :patientid => patientid,
        :parameter1 => includepix
      }
      magic(magic_parameters)
    end

    def get_patient_activity(userid, patientid)
      magic_parameters = {
        :action => "GetPatientActivity",
        :userid => userid,
        :patientid => patientid
      }
      magic(magic_parameters)
    end

    def get_patient_by_mrn
      raise NotImplementedError, "GetPatientByMRN magic action not implemented"
    end

    def get_patient_cda
      raise NotImplementedError, "GetPatientCDA magic action not implemented"
    end

    def get_patient_diagnosis
      raise NotImplementedError, "GetPatientDiagnosis magic action not implemented"
    end

    def get_patient_full
      raise NotImplementedError, "GetPatientFull magic action not implemented"
    end

    def get_patient_ids
      raise NotImplementedError, "GetPatientIDs magic action not implemented"
    end

    def get_patient_list
      raise NotImplementedError, "GetPatientList magic action not implemented"
    end

    def get_patient_locations
      raise NotImplementedError, "GetPatientLocations magic action not implemented"
    end

    def get_patient_pharmacies
      raise NotImplementedError, "GetPatientPharmacies magic action not implemented"
    end

    def get_patient_problems(patientid, show_by_encounter_flag = nil, assessed = nil, encounter_id = nil, medcin_id = nil)
      magic_parameters = {
        :action => "GetPatientProblems",
        :patientid => patientid,
        :parameter1 => show_by_encounter_flag,
        :parameter2 => assessed,
        :parameter3 => encounter_id,
        :parameter4 => medcin_id
      }
      magic(magic_parameters)
    end

    def get_patients_by_icd9(icd9, start = nil, end_param = nil)
      magic_parameters = {
        :action => "GetPatientsByICD9",
        :parameter1 => icd9,
        :parameter2 => start,
        :parameter3 => end_param
      }
      magic(magic_parameters)
    end

    def get_patient_sections
      raise NotImplementedError, "GetPatientSections magic action not implemented"
    end

    def get_procedures
      raise NotImplementedError, "GetProcedures magic action not implemented"
    end

    def get_provider(provider_id = nil, user_name = nil)
      if provider_id.nil? && user_name.nil?
        raise ArgumentError, "provider_id or user_name must be given"
      end

      magic_parameters = {
        :action => "GetProvider",
        :parameter1 => provider_id,
        :parameter2 => user_name
      }
      magic(magic_parameters)
    end

    def get_providers(security_filter = nil, name_filter = nil)
      magic_parameters = {
        :action => "GetProviders",
        :parameter1 => security_filter,
        :parameter2 => name_filter
      }
      magic(magic_parameters)
    end

    def get_ref_providers_by_specialty
      raise NotImplementedError, "GetRefProvidersBySpecialty magic action not implemented"
    end

    def get_rounding_list_entries
      raise NotImplementedError, "GetRoundingListEntries magic action not implemented"
    end

    def get_rounding_lists
      raise NotImplementedError, "GetRoundingLists magic action not implemented"
    end

    def get_rx_favs
      raise NotImplementedError, "GetRXFavs magic action not implemented"
    end

    def get_schedule
      raise NotImplementedError, "GetSchedule magic action not implemented"
    end

    def get_server_info
      magic_parameters = {
        :action => "GetServerInfo"
      }
      magic(magic_parameters)
    end

    def get_sigs
      raise NotImplementedError, "GetSigs magic action not implemented"
    end

    def get_task(userid, transaction_id)
      magic_parameters = {
        :action => "GetTask",
        :userid => userid,
        :parameter1 => transaction_id
      }
      magic(magic_parameters)
    end

    def get_task_list(userid = nil, since = nil)
      magic_parameters = {
        :action => "GetTaskList",
        :userid => userid,
        :parameter1 => since
      }
      magic(magic_parameters)
    end

    def get_user_authentication
      raise NotImplementedError, "GetUserAuthentication magic action not implemented"
    end

    def get_user_id
      raise NotImplementedError, "GetUserID magic action not implemented"
    end

    def get_user_security
      raise NotImplementedError, "GetUserSecurity magic action not implemented"
    end

    def get_vaccine_manufacturers
      raise NotImplementedError, "GetVaccineManufacturers magic action not implemented"
    end

    def get_vitals
      raise NotImplementedError, "GetVitals magic action not implemented"
    end

    def make_task
      raise NotImplementedError, "MakeTask magic action not implemented"
    end

    def save_admin_task
      raise NotImplementedError, "SaveAdminTask magic action not implemented"
    end

    def save_allergy
      raise NotImplementedError, "SaveAllergy magic action not implemented"
    end

    def save_ced
      raise NotImplementedError, "SaveCED magic action not implemented"
    end

    def save_charge
      raise NotImplementedError, "SaveCharge magic action not implemented"
    end

    def save_chart_view_audit
      raise NotImplementedError, "SaveChartViewAudit magic action not implemented"
    end

    def save_diagnosis
      raise NotImplementedError, "SaveDiagnosis magic action not implemented"
    end

    def save_document_image
      raise NotImplementedError, "SaveDocumentImage magic action not implemented"
    end

    def save_er_note
      raise NotImplementedError, "SaveERNote magic action not implemented"
    end

    def save_hie_document
      raise NotImplementedError, "SaveHIEDocument magic action not implemented"
    end

    def save_history
      raise NotImplementedError, "SaveHistory magic action not implemented"
    end

    def save_immunization
      raise NotImplementedError, "SaveImmunization magic action not implemented"
    end

    def save_note
      raise NotImplementedError, "SaveNote magic action not implemented"
    end

    def save_patient
      raise NotImplementedError, "SavePatient magic action not implemented"
    end

    def save_patient_location
      raise NotImplementedError, "SavePatientLocation magic action not implemented"
    end

    def save_problem
      raise NotImplementedError, "SaveProblem magic action not implemented"
    end

    def save_problems_data
      raise NotImplementedError, "SaveProblemsData magic action not implemented"
    end

    def save_ref_provider
      raise NotImplementedError, "SaveRefProvider magic action not implemented"
    end

    def save_result
      raise NotImplementedError, "SaveResult magic action not implemented"
    end

    def save_rx(userid, patientid, rxxml)
      # Generate XML structure for rxxml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.saverx {
          xml.field("name" => "transid", "value" => rxxml[:transid]) unless rxxml[:transid].nil?
          xml.field("name" => "PharmID", "value" => rxxml[:pharmid]) unless rxxml[:pharmid].nil?
          xml.field("name" => "DDI", "value" => rxxml[:ddi]) unless rxxml[:ddi].nil?
          xml.field("name" => "GPPCCode", "value" => rxxml[:gppccode]) unless rxxml[:gppccode].nil?
          xml.field("name" => "GPPCText", "value" => rxxml[:gppctext]) unless rxxml[:gppctext].nil?
          xml.field("name" => "GPPCCustom", "value" => rxxml[:gppccustom]) unless rxxml[:gppccustom].nil?
          xml.field("name" => "Sig", "value" => rxxml[:sig]) unless rxxml[:sig].nil?
          xml.field("name" => "QuanPresc", "value" => rxxml[:quanpresc]) unless rxxml[:quanpresc].nil?
          xml.field("name" => "Refills", "value" => rxxml[:refills]) unless rxxml[:refills].nil?
          xml.field("name" => "DAW", "value" => rxxml[:daw]) unless rxxml[:daw].nil?
          xml.field("name" => "DaysSupply", "value" => rxxml[:dayssupply]) unless rxxml[:dayssupply].nil?
          xml.field("name" => "startdate", "value" => utc_to_local(Date.parse(rxxml[:startdate].to_s))) unless rxxml[:startdate].nil?
          xml.field("name" => "historicalflag", "value" => rxxml[:historicalflag]) unless rxxml[:historicalflag].nil?
        }
      end

      magic_parameters = {
        :action => "SaveRX",
        :userid => userid,
        :patientid => patientid,
        :parameter1 => nokogiri_to_string(builder)
      }
      magic(magic_parameters)
    end

    def save_simple_encounter
      raise NotImplementedError, "SaveSimpleEncounter magic action not implemented"
    end

    def save_simple_rx
      raise NotImplementedError, "SaveSimpleRX magic action not implemented"
    end

    def save_specialist
      raise NotImplementedError, "SaveSpecialist magic action not implemented"
    end

    def save_task(userid, patientid, task_type = nil, target_user = nil, work_object_id = nil, comments = nil)
      if task_type.nil? && target_user.nil? && work_object_id.nil? && comments.nil?
        raise ArugmentError, "task_type, target_user, work_object_id, and comments can not all be nil"
      end

      magic_parameters = {
        :action => "SaveTask",
        :userid => userid,
        :patientid => patientid,
        :parameter1 => task_type,
        :parameter2 => target_user,
        :parameter3 => work_object_id,
        :parameter4 => comments
      }
      magic(magic_parameters)
    end

    def save_task_status(userid, transaction_id = nil, param = nil, delegate_id = nil, comment = nil)
      if transaction_id.nil? && param.nil? && delegate_id.nil? && comment.nil?
        raise ArugmentError, "task_type, target_user, work_object_id, and comments can not all be nil"
      end

      magic_parameters = {
        :action => "SaveTaskStatus",
        :userid => userid,
        :parameter1 => transaction_id,
        :parameter2 => param,
        :parameter3 => delegate_id,
        :parameter4 => comment
      }
      magic(magic_parameters)
    end

    def save_tiff
      raise NotImplementedError, "SaveTiff magic action not implemented"
    end

    def save_unstructured_document
      raise NotImplementedError, "SaveUnstructuredDocument magic action not implemented"
    end

    def save_v10_doc_signature
      raise NotImplementedError, "SaveV10DocSignature magic action not implemented"
    end

    def save_v11_note
      raise NotImplementedError, "SaveV11Note magic action not implemented"
    end

    def save_vitals
      raise NotImplementedError, "SaveVitals magic action not implemented"
    end

    def save_vitals_data
      raise NotImplementedError, "SaveVitalsData magic action not implemented"
    end

    def search_charge_codes
      raise NotImplementedError, "SearchChargeCodes magic action not implemented"
    end

    def search_diagnosis_codes
      raise NotImplementedError, "SearchDiagnosisCodes magic action not implemented"
    end

    def search_meds(userid, patientid, search = nil)
      magic_parameters = {
        :action => "SearchMeds",
        :userid => userid,
        :patientid => patientid,
        :parameter1 => search
      }
      magic(magic_parameters)
    end

    def search_patients
      raise NotImplementedError, "SearchPatients magic action not implemented"
    end

    def search_patients_rxhub5
      raise NotImplementedError, "SearchPatientsRXHub5 magic action not implemented"
    end

    def search_pharmacies
      raise NotImplementedError, "SearchPharmacies magic action not implemented"
    end

    def search_problem_codes
      raise NotImplementedError, "SearchProblemCodes magic action not implemented"
    end

    def update_encounter
      raise NotImplementedError, "UpdateEncounter magic action not implemented"
    end

    def update_order
      raise NotImplementedError, "UpdateOrder magic action not implemented"
    end

    def update_referral_order_status
      raise NotImplementedError, "UpdateReferralOrderStatus magic action not implemented"
    end

    protected

    def nokogiri_to_string(builder)
      builder.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
    end

    # Use TZInfo to convert a given UTC datetime into
    # a local
    def local_to_utc(datetime)
      if datetime.nil?
        return nil
      end

      is_date = datetime.instance_of?(Date)
      is_time = datetime.instance_of?(Time)

      if is_time || is_date
        datetime = DateTime.parse(datetime.to_s)
      end

      if datetime.is_a?(String)
        datetime = DateTime.parse(datetime)
      end

      if @timezone.nil?
        return datetime
      end

      datetime = @timezone.local_to_utc(datetime)

      if is_date
        return datetime.to_date
      end

      # Return a DateTime with a UTC offset
      datetime = DateTime.parse("#{datetime.strftime("%FT%T")}Z")

      return datetime.to_time if is_time
      return datetime.to_date if is_date
      return datetime
    end

    def utc_to_local(datetime = nil)
      if datetime.nil?
        return nil
      end

      is_date = datetime.instance_of?(Date)
      is_time = datetime.instance_of?(Time)

      if is_time || is_date
        datetime = DateTime.parse(datetime.to_s)
      end

      if datetime.is_a?(String)
        datetime = DateTime.parse(datetime)
      end

      if @timezone.nil?
        return datetime
      end

      datetime = @timezone.utc_to_local(datetime)

      # Return a DateTime with the correct timezone offset
      datetime = DateTime.parse(iso8601_with_offset(datetime))

      return datetime.to_time if is_time
      return datetime.to_date if is_date
      return datetime
    end

    # TZInfo does not correctly update a DateTime's
    # offset, so we manually format the ISO8601 with
    # the correct format
    def iso8601_with_offset(datetime)
      if datetime.nil?
        return nil
      end

      if @timezone.nil? || datetime.instance_of?(Date)
        return datetime.iso8601
      end

      offset = @timezone.current_period.utc_offset
      negative_offset = false
      datetime_string = datetime.strftime("%FT%T")

      if offset < 0
        offset *= -1
        negative_offset = true
      end

      if offset == 0
        # ISO8601 allows Z to be used instead of +00:00 for
        # UTC. Native Ruby Date#iso8601 uses +00:00. It doesn't
        # really matter, both are valid.
        offset_string = "Z"
      else
        offset_string = Time.at(offset).utc.strftime("%H:%M")
        offset_string = "-" + offset_string if negative_offset
      end

      "#{datetime_string}#{offset_string}"
    end

    def strip_attributes(response)
      # Base case: nil maps to nil
      if response.nil?
        return nil
      end

      # Recurse step: if the value is a hash then delete all
      # keys that match the attribute pattern that Nori uses
      if response.is_a?(Hash)
        response.delete_if do |key, value|
          is_attribute = key.to_s =~ /^@/

          unless is_attribute
            strip_attributes(value)
          end

          is_attribute
        end

        return response
      end

      # Recurse step: if the value is an array then delete all
      # keys within hashes that match the attribute pattern that
      # Nori uses
      if response.is_a?(Array)
        response.map do |value|
          strip_attributes(value)
        end

        return response
      end

      # Base case: value doesn't need attributes stripped
      response
    end

    def convert_dates_to_utc(response)
      # Base case
      if response.nil?
        return nil
      end

      # Recurse step: if the value is an array then convert all
      # Ruby date objects to UTC
      if response.is_a?(Array)
        return response.map do |value|
          convert_dates_to_utc(value)
        end
      end

      # Recurse step: if the value is a hash then convert all
      # Ruby date object values to UTC
      if response.is_a?(Hash)
        result = response.map do |key, value|
          { key => convert_dates_to_utc(value) }
        end

        # Trick to make Hash#map return a hash. Simply calls the merge method
        # on each hash in the array to reduce to a single merged hash.
        return result.reduce(:merge)
      end

      # Base case: convert date object to UTC
      if response.instance_of?(Time) || response.instance_of?(DateTime) || response.instance_of?(Date)
        return local_to_utc(response)
      end

      # Base case: value is not a date
      response
    end

    def encode_data(data)
      if data.nil?
        return nil
      end

      if data.respond_to?(:bytes)
        return data.bytes.pack("m")
      elsif data.is_a?(Array)
        return data.pack("m")
      end
    end

    def encode_date(possible_date)
      datetime_regex = /((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2}))(T| )\d{1,2}:\d{1,2}( ?PM|AM|pm|am)?/
      date_regex = /^((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2}))$/

      if possible_date.nil?
        return nil
      end

      # If the given object is an instance of one of the three core
      # Ruby date types, then do timezone conversion format to a
      # ISO8601 string.
      if possible_date.instance_of?(Time) || possible_date.instance_of?(DateTime) || possible_date.instance_of?(Date)
        possible_date = utc_to_local(possible_date)
        return possible_date.iso8601
      end

      # If the given object is a string, then try to detect if it
      # is a parsable timestamp using some quick and dirty regular
      # expressions.
      if possible_date.is_a?(String) && possible_date =~ datetime_regex
        possible_date = utc_to_local(possible_date)
        return possible_date.iso8601
      end

      if possible_date.is_a?(String) && possible_date =~ date_regex
        possible_date = utc_to_local(Date.parse(possible_date))
        return possible_date.iso8601
      end

      possible_date
    end

    def map_magic_request(parameters)
      action = parameters[:action]
      userid = parameters[:userid]
      appname = parameters[:appname] || @appname
      patientid = parameters[:patientid]
      token = parameters[:token] || @security_token
      parameter1 = encode_date(parameters[:parameter1])
      parameter2 = encode_date(parameters[:parameter2])
      parameter3 = encode_date(parameters[:parameter3])
      parameter4 = encode_date(parameters[:parameter4])
      parameter5 = encode_date(parameters[:parameter5])
      parameter6 = encode_date(parameters[:parameter6])
      data = encode_data(parameters[:data])

      return {
        "Action" => action,
        "UserID" => userid,
        "Appname" => appname,
        "PatientID" => patientid,
        "Token" => token,
        "Parameter1" => parameter1,
        "Parameter2" => parameter2,
        "Parameter3" => parameter3,
        "Parameter4" => parameter4,
        "Parameter5" => parameter5,
        "Parameter6" => parameter6,
        "data" => data
      }
    end

    def map_magic_response(response, action)
      result = response[:magic_response][:magic_result][:diffgram]

      # All magic responses wrap their result in an ActionResponse element
      result = result[:"#{action.downcase}response"]

      if result.nil? || result.blank?
        return {}
      end

      # Often the first element in ActionResponse is an element
      # called ActionInfo, but in some cases it has a different name
      # so we just get the first element.
      result = result.values.first
      strip_attributes(result)
      convert_dates_to_utc(result)
    end
  end
end