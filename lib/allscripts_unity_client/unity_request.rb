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
      parameter1 = encode_date(@parameters[:parameter1])
      parameter2 = encode_date(@parameters[:parameter2])
      parameter3 = encode_date(@parameters[:parameter3])
      parameter4 = encode_date(@parameters[:parameter4])
      parameter5 = encode_date(@parameters[:parameter5])
      parameter6 = encode_date(@parameters[:parameter6])
      data = encode_data(@parameters[:data])

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

    private

    def encode_date(possible_date)
      datetime_regex = /^((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2}))(T| )\d{1,2}:\d{1,2}( ?PM|AM|pm|am)?$/
      date_regex = /^((\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2}))$/

      if possible_date.nil?
        return nil
      end

      # If the given object is an instance of one of the three core
      # Ruby date types, then do timezone conversion format to a
      # ISO8601 string.
      if possible_date.instance_of?(Time) || possible_date.instance_of?(DateTime) || possible_date.instance_of?(Date)
        possible_date = @timezone.utc_to_local(possible_date)
        return possible_date.iso8601
      end

      # If the given object is a string, then try to detect if it
      # is a parsable timestamp using some quick and dirty regular
      # expressions.
      if possible_date.is_a?(String) && possible_date =~ datetime_regex
        possible_date = @timezone.utc_to_local(possible_date)
        return possible_date.iso8601
      end

      if possible_date.is_a?(String) && possible_date =~ date_regex
        possible_date = @timezone.utc_to_local(Date.parse(possible_date))
        return possible_date.iso8601
      end

      possible_date
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
  end
end