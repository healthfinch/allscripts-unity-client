module AllscriptsUnityClient

  # Transform a Unity request into a Hash suitable for sending using Savon.
  class UnityRequest
    attr_accessor :parameters, :appname, :security_token, :timezone, :raw_dates

    # Constructor.
    #
    # parameters:: A Hash of Unity parameters. Takes this form:
    #
    #   {
    #     'Action' => ...,
    #     'UserID' => ...,
    #     'Appname' => ...,
    #     'PatientID' => ...,
    #     'Token' => ...,
    #     'Parameter1' => ...,
    #     'Parameter2' => ...,
    #     'Parameter3' => ...,
    #     'Parameter4' => ...,
    #     'Parameter5' => ...,
    #     'Parameter6' => ...,
    #     'data' => ...
    #   }
    #
    # timezone:: An ActiveSupport::TimeZone instance.
    # appname:: The Unity license appname.
    # security_token:: A security token from the Unity GetSecurityToken call.
    def initialize(parameters, timezone, appname, security_token, raw_dates=false)
      raise ArgumentError, 'parameters can not be nil' if parameters.nil?
      raise ArgumentError, 'timezone can not be nil' if timezone.nil?
      raise ArgumentError, 'appname can not be nil' if appname.nil?
      raise ArgumentError, 'security_token can not be nil' if security_token.nil?

      @appname = appname
      @security_token = security_token
      @parameters = parameters
      @timezone = timezone
      @raw_dates = raw_dates
    end

    # Convert the parameters to a Hash for Savon with all possible dates
    # converted to the Organization's localtime.
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
      data = Utilities::encode_data(@parameters[:data])

      {
        'Action' => action,
        'UserID' => userid,
        'Appname' => appname,
        'PatientID' => patientid,
        'Token' => token,
        'Parameter1' => parameter1,
        'Parameter2' => parameter2,
        'Parameter3' => parameter3,
        'Parameter4' => parameter4,
        'Parameter5' => parameter5,
        'Parameter6' => parameter6,
        'data' => data
      }
    end

    protected

    def use_raw_dates?
      @raw_dates || false
    end

    def process_date(value)
      if value && (value.is_a?(Time) || value.is_a?(DateTime) || value.is_a?(ActiveSupport::TimeWithZone))
        return value.in_time_zone(@timezone).iso8601
      end

      return value if use_raw_dates?

      date = Utilities::try_to_encode_as_date(ActiveSupport::TimeZone['Etc/UTC'], value)

      if date && date.is_a?(ActiveSupport::TimeWithZone)
        date.in_time_zone(@timezone).iso8601
      elsif date && date.is_a?(Date)
        date.iso8601
      else
        value
      end
    end
  end
end
