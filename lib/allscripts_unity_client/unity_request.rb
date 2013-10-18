module AllscriptsUnityClient
  class UnityRequest
    def initialize(parameters, timezone, appname, security_token)
      raise ArgumentError, "parameters can not be nil" if parameters.nil?
      raise ArgumentError, "timezone can not be nil" if timezone.nil?
      raise ArgumentError, "appname can not be nil" if appname.nil?
      raise ArgumentError, "security_token can not be nil" if security_token.nil?

      @appname = appname
      @security_token = security_token
      @parameters = parameters
      @timezone = timezone
    end

    def to_hash
      action = @parameters[:action]
      userid = @parameters[:userid]
      appname = @parameters[:appname] || @appname
      patientid = @parameters[:patientid]
      token = @parameters[:token] || @security_token
      parameter1 = process_date(@parameters[:parameter1])
      parameter2 = process_date(@parameters[:parameter2])
      parameter3 = process_date(@parameters[:parameter3])
      parameter4 = process_date(@parameters[:parameter4])
      parameter5 = process_date(@parameters[:parameter5])
      parameter6 = process_date(@parameters[:parameter6])
      data = DataUtilities::encode_data(@parameters[:data])

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

    protected

    def process_date(value)
      if value.nil?
        return nil
      end

      result = DataUtilities::encode_date(value)

      if result.instance_of?(Time) || result.instance_of?(Date) || result.instance_of?(DateTime)
        return @timezone.utc_to_local(result)
      end

      value
    end
  end
end