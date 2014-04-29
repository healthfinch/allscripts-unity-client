module AllscriptsUnityClient
  class JSONUnityRequest < UnityRequest
    def to_hash
      action = @parameters[:action]
      userid = @parameters[:userid]
      appname = @parameters[:appname] || @appname
      patientid = @parameters[:patientid]
      token = @parameters[:token] || @security_token
      parameter1 = process_date(@parameters[:parameter1]) || ''
      parameter2 = process_date(@parameters[:parameter2]) || ''
      parameter3 = process_date(@parameters[:parameter3]) || ''
      parameter4 = process_date(@parameters[:parameter4]) || ''
      parameter5 = process_date(@parameters[:parameter5]) || ''
      parameter6 = process_date(@parameters[:parameter6]) || ''
      data = Utilities::encode_data(@parameters[:data]) || ''

      {
        'Action' => action,
        'AppUserID' => userid,
        'Appname' => appname,
        'PatientID' => patientid,
        'Token' => token,
        'Parameter1' => parameter1,
        'Parameter2' => parameter2,
        'Parameter3' => parameter3,
        'Parameter4' => parameter4,
        'Parameter5' => parameter5,
        'Parameter6' => parameter6,
        'Data' => data
      }
    end
  end
end