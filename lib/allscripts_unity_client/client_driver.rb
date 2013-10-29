module AllscriptsUnityClient
  class ClientDriver
    attr_accessor :username, :password, :appname, :base_unity_url, :proxy, :security_token, :timezone

    def initialize(base_unity_url, username, password, appname, proxy = nil, timezone = nil)
      raise ArgumentError, "base_unity_url can not be nil" if base_unity_url.nil?
      raise ArgumentError, "username can not be nil" if username.nil?
      raise ArgumentError, "password can not be nil" if password.nil?
      raise ArgumentError, "appname can not be nil" if appname.nil?

      @base_unity_url = base_unity_url.gsub /\/$/, ""
      @username = username
      @password = password
      @appname = appname
      @proxy = proxy

      unless timezone.nil?
        @timezone = Timezone.new(timezone)
      else
        @timezone = Timezone.new("UTC")
      end
    end

    def security_token?
      return !@security_token.nil?
    end

    def client_type
      return :none
    end

    def magic(parameters = {})
      raise NotImplementedError, "magic not implemented"
    end

    def get_security_token!(parameters = {})
      raise NotImplementedError, "get_security_token! not implemented"
    end

    def retire_security_token!(parameters = {})
      raise NotImplementedError, "retire_security_token! not implemented"
    end
  end
end